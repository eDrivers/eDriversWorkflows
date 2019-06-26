# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     LIBRARIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(sf)
library(raster)
library(magrittr)
library(tidyverse)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   IMPORT DRIVERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Identify drivers in drivers folder
folders <- dir('./Drivers/')

# Load driver layers
driverNames <- character()

# List of current objects in environment
obj <- c(ls(), 'obj', 'i', 'j','files', 'newName')

for(i in folders) {
  # File names + path
  files <- dir(paste0('./Drivers/', i, '/Data/Driver'), pattern = '.RData', full.names = T)

  # Load
  if (length(files) > 0) {
    for(j in files) load(j)
  }

  # Object Names
  newName <- ls()[!ls() %in% obj]

  # Update driver names list
  driverNames <- c(driverNames, newName)

  # Update obj list
  obj <- c(obj, newName)
}
