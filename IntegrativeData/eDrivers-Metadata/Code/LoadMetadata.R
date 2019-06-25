# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   IMPORT METADATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Identify drivers in drivers folder
folders <- dir('./Drivers/')

for(i in folders) {
  file.copy(from = dir(paste0('./Drivers/', i, '/Metadata/'), full.names = T),
            to = './IntegrativeData/eDrivers-Metadata/Data/')
}
