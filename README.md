# eDrivers workflows

Repository composed of all workflows used to generate individual drivers
characterized in the Estuary and Gulf of St. Lawrence and part of the eDrivers
initiative.

We strive to provide repositories with more or less the same structure:

**Structure**:

- Driver/
  - Code/
    - 1-loadData.R: loads relevant raw data
    - 2-formatData.R: formats raw data if necessary
    - 3-driver.R: generates the driver layer from the raw data and exports figure
  - Figures/
    - Driver.png: figure of the distribution and intensity of driver
  - Metadata/
    - Driver.?: metadata associated with the driver layer
  - Source/
    - Driver.bib: Bibtex file with relevant references to data used to generate driver layer
  - README.md: Relevant information on data description, methodologies and data citations
