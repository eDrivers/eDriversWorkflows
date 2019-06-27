# Eventually replace with direct queries from metadata and bibtex files
# For now this will do

# Empty data.frame
df <- data.frame(Groups = character(),
                 Drivers = character(),
                 FileName = character(),
                 Key = character(),
                 Source = character(),
                 stringsAsFactors = F)

# Individual driver description
df[1,] <- c("Climate",
            "Acidification",
            "Acidification",
            "ACID",
            "Starr and Chassé 2019")

df[2,] <- c("Climate",
            "Hypoxia",
            "Hypoxia",
            "HYP",
            'Blais et al. 2018')

df[3,] <- c("Climate",
            "Negative sea bottom temperature anomalies",
            "NegativeSBT",
            "SBT-",
            'Galbraith et al. 2018')

df[4,] <- c("Climate",
            "Positive sea bottom temperature anomalies",
            "PositiveSBT",
            "SBT+",
            df[3,]$Source)


df[5,] <- c("Climate",
            "Negative sea surface temperature anomalies",
            "NegativeSST",
            "SST-",
            df[3,]$Source)


df[6,] <- c("Climate",
            "Positive sea surface temperature anomalies",
            "PositiveSST",
            "SST+",
            df[3,]$Source)


df[7,] <- c("Climate",
            "Sea water level",
            "SeaLevel",
            "SLR",
            "Halpern et al. 2015")


df[8,] <- c("Coastal",
            "Aquaculture",
            "AquacultureInvertebrates",
            "AQUA",
            "MAPAQ 2016; DFO 2016a; AAF 2016; FA 2016; FFA 2016")


df[9,] <- c("Coastal",
            "Coastal development",
            "CoastalDevelopment",
            "CD",
            "Earth observation group 2019")


df[10,] <- c("Coastal",
             "Direct human impact",
             "DirectHumanImpact",
             "DHI",
             "Statistics Canada 2017")


df[11,] <- c("Coastal",
             "Inorganic pollution",
             "InorganicPollution",
             "IP",
             df[7,]$Source)



df[12,] <- c("Coastal",
             "Nutrient import",
             "NutrientInput",
             "NI",
             df[7,]$Source)


df[13,] <- c("Coastal",
             "Organic pollution",
             "OrganicPollution",
             "OP",
             df[7,]$Source)


df[14,] <- c("Coastal",
             "Toxic algae",
             "ToxicAlgae",
             "TA",
             "Bates et al. 2019")


df[15,] <- c("Fisheries",
             "Demersal, destructive",
             "FisheriesDD",
             "DD",
             "DFO 2016b")


df[16,] <- c("Fisheries",
             "Demersal, non-destructive, high-bycatch",
             "FisheriesDNH",
             "DNH",
             df[15,]$Source)


df[17,] <- c("Fisheries",
             "Demersal, non-destructive, low-bycatch",
             "FisheriesDNL",
             "DNL",
             df[15,]$Source)


df[18,] <- c("Fisheries",
             "Pelagic, high-bycatch",
             "FisheriesPHB",
             "PHB",
             df[15,]$Source)


df[19,] <- c("Fisheries",
             "Pelagic, low-bycatch",
             "FisheriesPLB",
             "PLB",
             df[15,]$Source)


df[20,] <- c("Marine traffic",
             "Invasive species",
             "InvasiveSpecies",
             "INV",
             df[7,]$Source)


df[21,] <- c("Marine traffic",
             "Marine pollution",
             "MarinePollution",
             "MP",
             df[7,]$Source)


df[22,] <- c("Marine traffic",
             "Shipping",
             "Shipping",
             "SHP",
             df[7,]$Source)

# Order table
df <- df[order(df$Groups, df$Drivers), ]

# Export table
driversList <- df
save(driversList, file = './IntegrativeData/eDrivers-List/Data/driversList.RData')
