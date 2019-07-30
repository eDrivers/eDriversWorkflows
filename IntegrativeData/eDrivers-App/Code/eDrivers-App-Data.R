# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    DESCRIPTION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data used for the shiny application called `eDrivers`
# Eventually, this should be replaced by a direct call to the `eDrivers` R
# package, but for now we keep things simple and have a data version specific
# to the application since the resolution of the data is coarser for application
# speed purposes.
#
# The data products are:
#   - driver[[1]] <- data as `raster` object
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     LIBRARIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(magrittr)
library(raster)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                IMPORT & FORMAT DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get list of data
load('./IntegrativeData/eDrivers-List/Data/driversList.RData')
dr <- driversList$FileName

# Load all driver layers
for(i in dr) load(paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1500m2/Data/', i, '.RData'))


# Transform raster projections
# This is the projection for the leaflet map I am working with
prj <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"
for(i in dr) assign(i, raster::projectRaster(get(i), crs = prj))

# Embed drivers in a list
drivers <- mget(dr)

# Round data to the 4th decimal
for(i in 1:length(drivers)) drivers[[i]] <- round(drivers[[i]], 4)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     RAW DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create object with raw data to export and allow user to visualize untransformed data
rawDrivers <- drivers

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                 TRANSFORMED DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Log-transform drivers that should be transformed
# Name of drivers to transform
drTrans <- c('coastDev','dirHumImpact','fisheriesDD', 'fisheriesDNH','fisheriesDNL',
             'fisheriesPHB','fisheriesPLB','Hypoxia','inorgPol','invasives',
             'nutrientInput','orgPol','negSBT','posSBT','shipping')

# Log transform
id <- which(names(drivers) %in% drTrans)
for(i in id) drivers[[i]] <- log(drivers[[i]] + 1)

# Scale drivers between 0 and 1 using the 99th quantile
# Function
quantNorm <- function(x) {
  id <- x != 0
  x <- x / quantile(x[id], probs = .99, na.rm = T)
  x[x > 1] <- 1
  x[x < 0] <- 0
  x
}

# Scaling
for(i in 1:length(drivers)) drivers[[i]] <- quantNorm(drivers[[i]])



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     HOTSPOTS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Extract hotspots
hotspots <- drivers
for(i in 1:length(hotspots)) {
  # Raster values
  vals <- values(hotspots[[i]])

  # Identify values over 0
  id0 <- vals > 0

  # Evaluate hotspot threshold value
  th <- quantile(vals[id0], probs = .8, na.rm = T)

  # Transform raster as binary hotspot data
  hotspots[[i]] <- calc(hotspots[[i]], fun = function(x) ifelse(x > th, 1, NA))
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                REMOVE 0 OR - VALUES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set values <= 0 to NA
for(i in 1:length(drivers)) {
  rawDrivers[[i]][] <- ifelse(rawDrivers[[i]][] <= 0, NA, rawDrivers[[i]][])
  drivers[[i]][] <- ifelse(drivers[[i]][] <= 0, NA, drivers[[i]][])
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   RASTER STACKS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Transform into raster stacks
rawDrivers <- stack(rawDrivers)
drivers <- stack(drivers)
hotspots <- stack(hotspots)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   EXPORT STACKS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Export drivers and hotspots list
save(rawDrivers, file = './IntegrativeData/eDrivers-App/Data/rawDrivers.RData')
save(drivers, file = './IntegrativeData/eDrivers-App/Data/drivers.RData')
save(hotspots, file = './IntegrativeData/eDrivers-App/Data/hotspots.RData')

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  EXPORT MATRICES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Drivers data as matrix and remove NAs
dr <- as.matrix(drivers)
id0 <- apply(dr, 1, function(x) !all(is.na(x)))
dr <- dr[id0, ]
dr <- dr %>%
      '*'(1000) %>%
      round() %>%
      ifelse(. == 0, NA, .) %>%
      as.data.frame()

save(dr, file = './IntegrativeData/eDrivers-App/Data/dr.RData')

# Hotspots data as matrix and remove NAs
hot <- as.matrix(hotspots)
id0 <- apply(hot, 1, function(x) !all(is.na(x)))
hot <- hot[id0, ]
hot <- hot %>%
       ifelse(. == 0, NA, .) %>%
       as.data.frame()
hot <- as.data.frame(hot)

save(hot, file = './IntegrativeData/eDrivers-App/Data/hot.RData')
