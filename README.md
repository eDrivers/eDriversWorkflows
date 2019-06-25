# eDrivers workflows

Repository composed of all workflows used to generate individual drivers
characterized in the Estuary and Gulf of St. Lawrence and part of the eDrivers
initiative.

<!-- git submodule update --recursive --remote -->

## Driver repositories structure

We strive to provide repositories with more or less the same structure:

**Structure**:


- `Driver/`
  - `Code/`
    - `1-Data.R`: loads and formats relevant raw data
    - `3-Driver.R`: generates the driver layer from the raw data and exports figure
    - additional `.R` files containing sourced functions
  - `Data/`
    - `Driver/`
      - `Driver.RData`: R object containing the driver layer produced
    - `RawData/`
      - This folder is empty, but used for the workflow of most driver layers to store data
  - `Figures/`
    - `Driver.png`: figure of the distribution and intensity of driver
  - `Metadata/`
    - `Driver.?`: metadata associated with the driver layer
  - `Source/`
    - `Driver.bib`: Bibtex file with relevant references to data used to generate driver layer
  - `README.md`: Relevant information on data description, methodologies and data citations

## Projection

Coordinate Reference System:

- [NAD83 / Quebec Lambert](https://epsg.io/32198)
- EPSG: 32198
- proj4string: "+proj=lcc +lat_1=60 +lat_2=46 +lat_0=44 +lon_0=-68.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
