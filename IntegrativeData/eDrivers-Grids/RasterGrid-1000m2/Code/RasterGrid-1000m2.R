# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     LIBRARIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(sf)
library(raster)
library(magrittr)
library(tidyverse)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                       GRID
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
load('./Grids/Data/RasterGrid-1000m2.RData')


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   IMPORT DRIVERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source('./IntegrativeData/eDrivers-Grids/LoadDrivers.R')

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# Set projections manually
#
# This is problematic, will have to figure out why certain rasters do not have
# the proper projection even though they are projected in the workflow.
# The layers that pose a problem are those from the global datasets
pj <- "+proj=lcc +lat_1=60 +lat_2=46 +lat_0=44 +lon_0=-68.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
st_crs(InvasiveSpecies)$proj4string <- pj
st_crs(MarinePollution)$proj4string <- pj
st_crs(NutrientInput)$proj4string <- pj
st_crs(OrganicPollution)$proj4string <- pj
st_crs(SeaLevel)$proj4string <- pj
st_crs(Shipping)$proj4string <- pj
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                               IMPORT DRIVERS IN GRID
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Presence absence driver data, using max of cell values
maxDriver <- c('AquacultureInvertebrates', 'ToxicAlgae')
for(i in maxDriver) {
  # Rasterize data
  r <- rasterize(x = get(i), y = rasterGrid, field = i, fun = max)

  # Change layer name
  names(r) <- i

  # Save under driver name
  assign(i, r)

  # Export raster
  save(list = i, file = paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data/', i, '.RData'))
}

# Point drivers that need to be given a buffer (eventually the data will be
# properly formatted)
ptDriver <- c('NegativeSBT','NegativeSST','PositiveSBT','PositiveSST')
for(i in ptDriver) {
  # Buffer around points
  r <- st_buffer(get(i), 2000)

  # Rasterize data
  r <- rasterize(x = r, y = rasterGrid, field = i, fun = max)

  # Change layer name
  names(r) <- i

  # Save under driver name
  assign(i, r)

  # Export raster
  save(list = i, file = paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data/', i, '.RData'))
}

# Quantitative data using the mean of the overlapping cells
quantDrivers <- driverNames[!driverNames %in% c(maxDriver,ptDriver)]
for(i in quantDrivers) {
  # Rasterize data
  r <- rasterize(x = get(i), y = rasterGrid, field = i, fun = mean)

  # Change layer name
  names(r) <- i

  # Save under driver name
  assign(i, r)

  # Export raster
  save(list = i, file = paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data/', i, '.RData'))
}
