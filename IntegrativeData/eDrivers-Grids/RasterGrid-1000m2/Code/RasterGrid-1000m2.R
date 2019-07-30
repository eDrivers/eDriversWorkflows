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
  r <- rasterize(x = r, y = appGrid, field = i, fun = max)

  # Change layer name
  names(r) <- i

  # Save under driver name
  assign(i, r)

  # Export raster
  save(list = i, file = paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data/', i, '.RData'))
}

# Quantitative data using the mean of the overlapping cells
quantDrivers <- driverNames[!driverNames %in% maxDriver]
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
