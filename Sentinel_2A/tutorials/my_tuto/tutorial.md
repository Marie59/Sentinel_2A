---
layout: tutorial_hands_on

title: Sentinel 2 biodiversity
zenodo_link: ''
questions:
- How to get spectral and biodiversity indicators from remote sensing data ?
- Which kind of ecosystem are you studying ? global or canopy data ?
objectives:
- Getting Sentinel 2 data and reformating them in a generalize way
- Computing spectral indices such as the NDVI
- Calculating and vizualizing biodiversity indicators
- Comparing with in-situ data 
time_estimation: 2H
key_points:
- Remote sensing data
- Biodiversity indicators
contributors:
- Marie59

---


# Introduction
{:.no_toc}

<!-- This is a comment. -->

This tutorial will guide you on getting Sentinel 2 data and processing them in order to calculate and visualize biodiversity indicators. This workflow made of 6 tools will allow you to explore Sentinel 2 data in the view of making biodiversity analyses.

Spatial diversity measurements should not replace in situ biodiversity data, but rather complement existing data and approaches. Spatial diversity estimates are currently based on long time scales, allowing more general predictions about rates of change in diversity. In practice, spatial data incorporate information on surface properties, including functional aspects, taxonomy, phylogeny and genetic diversity. 

The tools explained here are useful for observing variations in spatial and temporal ecosystem properties given the intrinsic relationship between spatial variations in ecosystems and pixel values of spectral signals. A single measurement cannot provide a complete description of all the different aspects of ecosystem heterogeneity. Therefore, the combination of multiple tools in a Galaxy-Ecology workflow offers multiple approaches to unravel the complexity of ecosystem heterogeneity in space and time. 

So, we will compute biodiversity and spectral indices.

> ### {% icon details %} Definition of reflectance
>
> The reflectance is a porportion on reflected light on an area. It's the ration between the electromagnetic incident wave on the area and the reflected wave. It's often a percentage between reflected intensity and inicident intensity assumed as energy quantity.
>
{: .details}

> ![Sentinel 2 toolsuite workflow](images/Sentinel_2.png "Sentinel 2 toolsuite workflow")

Each part of this workflow has elementary steps :
 - **A first step** to preprocess Sentinel 2 data:
   - Preprocess Sentinel 2 data
 - **A second step** to compute biodiversity indicators
   - Global overview
   - For Canopy
 - **A third step** to compute spectral indices:
   - Spectral indices 
   - EBV

> ### {% icon details %} Details about spectral indices
>
> Spectral indices are used to highlight particular features or properties of the earth's surface, e.g. vegetation, soil, water. They are developed on the basis of the spectral properties of the object of interest.
>
> Knowledge of the leaf cell, plant structure, state, condition and spectral properties is essential to perform vegetation analysis using remote sensing data.   
> Spectral indices dedicated to vegetation analysis are developed on the basis that healthy vegetation reflects strongly in the near infrared (NIR) spectrum while absorbing strongly in the visible red.   
>
{: .details}


In this tutorial, we'll be working on Sentinel 2 data extracted from the Copernicus portal, Scihub.  First those data will be prepared. After pre-processing to fit the input format of the tools, we'll see how to calculate biodiversity metrics.

>
> ### Agenda
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

## Upload and pre-processing of the data

This first step consist of downloading and properly prepare the data to use it in Sentinel 2 toolsuite.

> ### {% icon hands_on %} Hands-on: Data upload
>
> 1. Create a new history for this tutorial and give it a name (example: “Sentinel 2 data for biodiversity tutorial”) for you to find it again later if needed.
>
>    {% snippet faqs/galaxy/histories_create_new.md box_type="none" %}
>
>
> 2. Download the files from [Scihub]({{ https://scihub.copernicus.eu/dhus/#/home }}) or from [PEPS]({{ https://peps.cnes.fr/rocket/#/search?maxRecords=50&page=1 }}) :
>
>    You will have to to create an account for either of these platform. 
>    Select Sentinel 2 and choose the Product type "S2MSI2A".
>
>    ![Scihub portal](images/Scihub.png "Scihub portal")
>
>    This an example of the Copernicus portal, Scihub. You need to download a zip folder. Keep it that way. 
>
> 3. Upload the zip folder
>
>     > ### {% icon tip %} Tip: Importing data from your computer
>     >
>     > * Open the Galaxy Upload Manager {% icon galaxy-upload %}
>     > * Select **Choose local files**
>     > * Browse in your computer and get the downloaded zip folder
>     >
>     > * Press **Start**
>     {: .tip}
>
> 4. Rename the datasets “sentinel_2_data.zip" for example and preview your dataset
>
>
{: .hands_on}

# Preparing data

>   Unzips, reads and preprocesses Sentinel 2 zip folder data.

## **Preprocessing sentinel 2 data**

> ### {% icon hands_on %} Hands-on: Preprocess
>
> 1. {% tool [Preprocessing sentinel 2 data](SRS_preprocess_S2) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `sentinel_2_data.zip` (Input dataset)
>    - {% icon param-select %} *"Where does your data come from ?"*: 'From Scihub or Peps'
>
> 2. Click on **Execute** 
>
>    > ### {% icon comment %} Comment
>    >
>    > The interesting output is the ENVI image format which is a binary raster file with an accompanying header file. The data are stored as a binary stream of bytes in a bil file without extension and the metadata are stored in the .hdr file. These data are in the output **Reflectance**. You can directly use the output **Reflectance** for the rest of the analysis.
>    {: .comment}
>
{: .hands_on}

> ![Preprocessing outputs](images/preproc.png "Preprocessing outputs")


> ### {% icon question %} Question
>
> 1. What are the files you are interested in for the folowing tools ?
>
> > ### {% icon solution %} Solution
> >
> > 1. The 2 files in the **Refelectance** folder that finish by "_Refl" and "_Refl.hdr"
> >
> {: .solution}
>
{: .question}

# Producing biodiversity indicators

>   You can choose to compute spectral and biodiversity indicators either for global remote sensing data or for a canopy.

{% include _includes/cyoa-choices.html option1="Global" option2="Canopy" default="Global"
       text="Here you can choose which tutorial you want to folllow according to if your are more interested about studying canopy remote sensing data or more global ones" %}

<div class="Global" markdown="1">
## **Compute a PCA**

> ### {% icon hands_on %} Hands-on: Principal components analysis for remote sensing data
>
> 1. {% tool [Compute a PCA](SRS_PCA) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Do you want to do a PCA or a SPCA ?"*: 'PCA'
>
>
>    > ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    >
>    > **TODO**: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    > * Go on your raster data 
>    > * Click on {% icon galaxy-pencil %} to edit it
>    > * Click on {% icon galaxy-chart-select-data %} Datatypes
>    > * On "New Type" **Select** bil 
>    > * Press **Save**
>    >
>    >
>    >    > ### {% icon comment %} Comment
>    >    >
>    >    > Do the same for the raster header with the datatype hdr
>    >    {: .comment}
>    >
>    {: .tip}
>    >
>
{: .hands_on}

## **Compute biodiversity indices**

> ### {% icon hands_on %} Hands-on: Biodiversity indicators for global remote sensing data
>
> 1. {% tool [Compute biodiversity indices](SRS_global_indices) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-text %} *"Write a number of the value of alpha"*: '1'
>
>
>    > ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    >
>    > **TODO**: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    > * Go on your raster data 
>    > * Click on {% icon galaxy-pencil %} to edit it
>    > * Click on {% icon galaxy-chart-select-data %} Datatypes
>    > * On "New Type" **Select** bil 
>    > * Press **Save**
>    >
>    >
>    >    > ### {% icon comment %} Comment
>    >    >
>    >    > Do the same for the raster header with the datatype hdr
>    >    {: .comment}
>    >
>    {: .tip}
>    >
>
>    > ### {% icon tip %} Tip: You can use the output of **Compute a PCA**
>    >
>    > - {% icon param-select %} *"In which format are your data ?"*: 'Your already have the files in ENVI BIL format'
>    > - {% icon param-file %} *"Input raster"*: `PCA raster` (output of **Compute a PCA** {% icon tool %})
>    > - {% icon param-file %} *"Input header"*: `PCA header` (output of **Compute a PCA** {% icon tool %})
>    > - {% icon param-text %} *"Write a number of the value of alpha"*: '1'
>    >
>    >
>    > ***TODO***: *Here again check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    {: .tip}
>
{: .hands_on}

> ![Global biodiveristy tabular](images/rasterdivtab.png "Global biodiveristy tabular") 
> ![Global biodiveristy graph](images/rasterdiv.png "Global biodiveristy graph")

> These 2 pictures are only exemple it is normal if you don't have exactly the same output.


> ### {% icon question %} Question
>
> 1. How many biodiversity indicators do you have ?
>
> > ### {% icon solution %} Solution
> >
> > 1. You should have 7 of them (Shannon, Renyi, Prao, Pielou, Hill, CRE, Berger-Parker). If you have only 5 of them, no problem, it just means you data are too small to compute CRE and Pielou but you can still continue your analysis.
> >
> {: .solution}
>
{: .question}
</div>

<div class="Canopy" markdown="1">
## **Compute a PCA**

> ### {% icon hands_on %} Hands-on: Principal components analysis for remote sensing data
>
> 1. {% tool [Compute a PCA](SRS_PCA) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Do you want to do a PCA or a SPCA ?"*: 'PCA'
>
>
>    > ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    >
>    > **TODO**: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    > * Go on your raster data 
>    > * Click on {% icon galaxy-pencil %} to edit it
>    > * Click on {% icon galaxy-chart-select-data %} Datatypes
>    > * On "New Type" **Select** bil 
>    > * Press **Save**
>    >
>    >
>    >    > ### {% icon comment %} Comment
>    >    >
>    >    > Do the same for the raster header with the datatype hdr
>    >    {: .comment}
>    >
>    {: .tip}
>    >
>
>
{: .hands_on}

## **Mapping diversity**

> ### {% icon hands_on %} Hands-on: Biodiversity indicators for canopy remote sensing data
>
> 1. {% tool [Mapping diversity](SRS_diversity_maps) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Alpha, beta, functional diversity and comparison plot and map"*: 'All of the above'
>
>
>    > ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    >
>    > **TODO**: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    > * Go on your raster data 
>    > * Click on {% icon galaxy-pencil %} to edit it
>    > * Click on {% icon galaxy-chart-select-data %} Datatypes
>    > * On "New Type" **Select** bil 
>    > * Press **Save**
>    >
>    >
>    >    > ### {% icon comment %} Comment
>    >    >
>    >    > Do the same for the raster header with the datatype hdr
>    >    {: .comment}
>    >
>    {: .tip}
>    >
>
{: .hands_on}

> ![Alpha diversity map](images/alpha.png "Alpha diversity map")
> ![Functionnal diversity tabular](images/funct_tb.png "Functionnal diversity tabular")

## **Processing remote sensing data**

> ### {% icon hands_on %} Hands-on: Comparing biodiversity indicators for canopy
>
> 1. {% tool [Processing remote sensing data](SRS_process_data) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-file %} *"Plots folder zip"*: `output` (Input dataset)
>
>    > ### {% icon comment %} Shapefiles
>    >
>    > Here you must provide your folder of shapefiles (at least 2 in oder to have the beta diversity).
>    {: .comment}
>    ***TODO***: *Check parameter descriptions*
>
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
{: .hands_on}

> ![Biodiversity comparison graph](images/comp_bdmr.png "Biodiversity comparison graph")
> ![Bray curtis table](images/braycu.png "Bray curtis table")


> ### {% icon question %} Questions
>
> 1. What kind of data do you need to use these tools ?
> 2. Do you need a shapefile for mapping the diversity ?
> 3. Why do you need multiple locations for comparing biodiversity ? 
>
> > ### {% icon solution %} Solution
> >
> > 1. This analisys is for data on forest, it's a canopy study.
> > 2. No, only for the comparison with in situ data.
> > 3. The Bray curtis table compare the diversity between locations.
> >
> {: .solution}
>
{: .question}
</div>

# Spectral indices
>
> ### {% icon hands_on %} Hands-on: compute spectral indices
>
> 1. {% tool [Compute spectral indices](SRS_canopy_indices) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>
>    - {% icon param-select %} *"Input the type of indice you want"*: 'NDVI'
>
>    - {% icon param-select %} *"Do you want the raster layer of the indice as an output ?"*: 'No'
>
>
>    > ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    >
>    > **TODO**: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>    >
>    > * Go on your raster data 
>    > * Click on {% icon galaxy-pencil %} to edit it
>    > * Click on {% icon galaxy-chart-select-data %} Datatypes
>    > * On "New Type" **Select** bil 
>    > * Press **Save**
>    >
>    >
>    >    > ### {% icon comment %} Comment
>    >    >
>    >    > Do the same for the raster header with the datatype hdr
>    >    {: .comment}
>    >
>    {: .tip}
>    >
>    > ### {% icon comment %} Comment
>    >
>    > You can choose whichever indice you want
>    >
>    {: .comment}
>    >
{: .hands_on}


> ![ndvi](images/ndvi.png "Normalized different vegetation index tabular")


> ### {% icon details %} Spectral indices and Essential Biodiversity Variables 
>
> Remotely sensed diversity is consistent with most of the essential spatially constrained biodiversity variables proposed by Skidmore et al. (2015). This highlights the need for increased dialogue and collaboration between the biodiversity monitoring community and the remote sensing community to make satellite remote sensing a tool of choice for conservation. Increased dialogue is also essential within the biodiversity monitoring community to achieve this. From this point of view multiple Satellite Remote Sensing EBV (SRS EBV) were created.
> Some of the indices proposed here will allow you to compute  SRS EBV.
> For instance it allows you to compute one of GEO BON EBV [Canopy Chlorophyll Content]({{ https://portal.geobon.org/ebv-detail?id=13 }}). This EBV is computed by GEO BON on the Netherlands, here you can compute it on which ever Sentinel 2 data you want by chosing to calculate the indice CCCI.
{: .details}
>
> ![ebv](images/ccci.png "Canopy Chlorophyl Content index graph")

> ### {% icon question %} Questions
>
> 1. What's the difference between biodiversity indicators and spectral indices ?
>
> > ### {% icon solution %} Solution
> >
> > 1. Biodiversity indicators give us informations on the heterogeneity of the landscape whereas spectral indices inform us on the well being of the vegetation.
> >
> {: .solution}
>
{: .question}


# Conclusion
{:.no_toc}

You are now all set to use your remote sensing data in order to do a biodiversity analysis. Before you go on one last reflexion.

> ### {% icon question %} Questions
>
> 1. Should remote sensing replace in-situ data ?
>
> > ### {% icon solution %} Solution
> >
> > 1. NO ! remote sensing and in-situ data should come and complete one another to have the most complete view of the state of biodiversity.
> >
> {: .solution}
>
{: .question}
