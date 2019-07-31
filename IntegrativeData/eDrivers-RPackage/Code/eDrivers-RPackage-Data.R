# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    DESCRIPTION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data used in the first version of the R package called `eDrivers`
# The data product consists of a list object for each drivers containing:
#   - driver[[1]] <- data as `raster` object
#   - driver[[2]] <- metadata as `yaml` object
#   - driver[[3]] <- source as `bibentry` object

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     LIBRARIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(raster)
library(yaml)
library(RefManageR)
library(magrittr)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                           IMPORT, FORMAT & EXPORT DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get object names
objNames <- dir('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data') %>%
            gsub('.RData','',.)

# Create objects and import data
for(i in objNames) {
  # Raster data
  load(paste0('./IntegrativeData/eDrivers-Grids/RasterGrid-1000m2/Data/', i, '.RData'))

  # Metadata
  meta <- read_yaml(paste0('./IntegrativeData/eDrivers-Metadata/Data/', i, '.yaml'))

  # Source
  bib <- ReadBib(paste0('./IntegrativeData/eDrivers-Source/Data/', i, '.bib'))

  assign(i,
    list(Data = get(i),
         Metadata = meta,
         Source = bib))

  # Export
  save(list = i, file = paste0('./IntegrativeData/eDrivers-RPackage/Data/', i, '.RData'))
}
