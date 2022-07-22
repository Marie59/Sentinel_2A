---
layout: tutorial_hands_on

title: Sentinel_2A_biodiversity
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
- yvanlebras

---


# Introduction
{:.no_toc}

<!-- This is a comment. -->

This tutorial will guide you on getting Sentinel 2A data and processing them in order to calculate and visualize biodiversity indicators.
We’ll be using data extracted from the Copernicus portal, Scihub.  First those data will be reformated. We’ll explore this dataset in the view of making biodiversity analyses so we will compute alpha and beta indicators, calculate Shannon, Hill and others indices and finally plot how the data is distributed through space and time, etc … .

> ### Agenda
>
> In this tutorial, we will cover:
>
> 1. TOC
> {:toc}
>
{: .agenda}

## Get data

> ### {% icon hands_on %} Hands-on: Data upload
>
> 1. Create a new history for this tutorial and give it a name (example: “Sentinel 2A data for biodiversity tutorial”) for you to find it again later if needed.
>    {% snippet faqs/galaxy/histories_create_new.md box_type="none" %}
> 2. Download the files from [Scihub]({{ https://scihub.copernicus.eu/dhus/#/home }}) or from
>    [PEPS]({{ https://peps.cnes.fr/rocket/#/search?maxRecords=50&page=1 }} :
>
>    You will have to to create an account for either of these platform. 
>    Select Sentinel 2 and choose the Product typE "S2MSI2A".
>    You need download a zip folder. Keep it that way. 
> 3. Upload the zip folder
>
> ### {% icon tip %} Tip: Importing data from your computer
>
>    * Open the Galaxy Upload Manager {% icon galaxy-upload %}
>    * Select **Choose local files**
>    * Browse in your computer and get the downloaded zip folder
>    * Press **Start**
{: .tip}
>
> 4. Rename the datasets “sentinel_2a_data.zip" for example and preview your dataset
>
>
{: .hands_on}

# Reformating data

>   Unzips, reads and preprocesses Sentinel 2A zip folder data.

## Sub-step with **Preprocessing sentinel 2 data**

> ### {% icon hands_on %} Hands-on: Preprocess
>
> 1. {% tool [Preprocessing sentinel 2 data](SRS_preprocess_S2) %} with the following parameters:
>    - {% icon param-file %} *"Input data"*: `sentinel_2a_data.zip` (Input dataset)
>    - {% icon param-select %} *"Where does your data come from ?"*: 'From Scihub or Peps'
>
> 2. Click on **Execute** 
>
>    > ### {% icon comment %} Comment
>    >
>    > The interesting output is the ENVI image format which is a flat-binary raster file with an accompanying ASCII header file. The data are stored as a binary stream of bytes in a file without extension and the metadata are stored in the .hdr file. Theese data are in the output **Reflectance**.
>    {: .comment}
>
{: .hands_on}

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> ### {% icon question %} Questions
>
> 1. Question1?
>
> > ### {% icon solution %} Solution
> >
> > 1. Answer for question1
> >
> {: .solution}
>
{: .question}

# Producing biodiversity indicateurs

>   You can choose to compute spectral and biodiversity indicators either for global remote sensing data or for a canopy.

## Sub-step with **Compute spectral indices**

> ### {% icon hands_on %} Hands-on: spectral indices
>
> 1. {% tool [Compute spectral indices](SRS_canopy_indices) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Input the type of indice you want"*: 'NDVI'
>    - {% icon param-select %} *"Do you want the raster layer of the indice as an output ?"*: 'No'
>
> ### {% icon tip %} Tip: If you want to use your own files ENVI BIL
>    ***TODO***: *Check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>
>    * Go on your raster data 
>    * Click on {% icon galaxy-pencil %} to edit it
>    * Click on {% icon galaxy-chart-select-data %} Datatypes
>    * On "New Type" **Select** bil 
>    * Press **Save**
>
>    > ### {% icon comment %} Comment
>    >
>    > Do the same for the raster header with the datatype hdr
>    {: .comment}
{: .tip}
>
>    > ### {% icon comment %} Comment
>    >
>    > You can choose whichever indice you want
>    {: .comment}
>
{: .hands_on}

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> ### {% icon question %} Questions
>
> 1. Question1?
>
> > ### {% icon solution %} Solution
> >
> > 1. Answer for question1
> >
> {: .solution}
>
{: .question}

{% include _includes/cyoa-choices.html option1="Global" option2="Canopy" default="Global"
       text="Here you can choose which tutorial you want to folllow according to if your are more interested about studying canopy remote sensing data or more global ones" %}

<div class="Global" markdown="1">
## Sub-step with **Compute a PCA raster**

> ### {% icon hands_on %} Hands-on: Principal components analysis for remote sensing data
>
> 1. {% tool [Compute a PCA raster](SRS_PCA) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Do you want to do a PCA or a SPCA ?"*: 'PCA'
>
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
>
{: .hands_on}

## Sub-step with **Compute biodiversity indices**

> ### {% icon hands_on %} Hands-on: Biodiversity indicators for global remote sensing data
>
> 1. {% tool [Compute biodiversity indices](SRS_global_indices) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-text %} *"Write a number of the value of alpha"*: '1'
>
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
>
> ### {% icon tip %} Tip: You can use the output of **Compute a PCA raster**
>    - {% icon param-select %} *"In which format are your data ?"*: 'Your already have the files in ENVI BIL format'
>      - {% icon param-file %} *"Input raster"*: `PCA raster` (output of **Compute a PCA raster** {% icon tool %})
>      - {% icon param-file %} *"Input header"*: `PCA header` (output of **Compute a PCA raster** {% icon tool %})
>    - {% icon param-text %} *"Write a number of the value of alpha"*: '1'
>
>
>    ***TODO***: *Here again check that the "Input raster" is bil datatype and that "Input raster header" is a hdr datatype*
>
{: .tip}
>
{: .hands_on}

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> ### {% icon question %} Questions
>
> 1. Question1?
>
> > ### {% icon solution %} Solution
> >
> > 1. Answer for question1
> >
> {: .solution}
>
{: .question}
</div>

<div class="Canopy" markdown="1">
## Sub-step with **Compute a PCA raster**

> ### {% icon hands_on %} Hands-on: Principal components analysis for remote sensing data
>
> 1. {% tool [Compute a PCA raster](SRS_PCA) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Do you want to do a PCA or a SPCA ?"*: 'PCA'
>
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
>
{: .hands_on}

## Sub-step with **Mapping diversity**

> ### {% icon hands_on %} Hands-on: Biodiversity indicators for canopy remote sensing data
>
> 1. {% tool [Mapping diversity](SRS_diversity_maps) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-select %} *"Alpha, beta, functional diversity and comparison plot and map"*: 'All of the above'
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
{: .hands_on}

## Sub-step with **Processing remote sensing data**

> ### {% icon hands_on %} Hands-on: Comparing biodiversity indicators for canopy
>
> 1. {% tool [Processing remote sensing data](SRS_process_data) %} with the following parameters:
>    - {% icon param-select %} *"In which format are your data ?"*: 'The data you are using are in a zip folder Reflectance'
>      - {% icon param-file %} *"Input data"*: `Reflectance` (output of **Preprocessing sentinel 2 data** {% icon tool %})
>    - {% icon param-file %} *"Plots folder zip"*: `output` (Input dataset)
>
>    ***TODO***: *Check parameter descriptions*
>
>    ***TODO***: *Consider adding a comment or tip box*
>
>    > ### {% icon comment %} Check datatype if you use your own ENVI BIL files
>    >
>    > Same as the compute spectral indices make sure you have the right datatypes bil and hdr.
>    {: .comment}
>
{: .hands_on}

***TODO***: *Consider adding a question to test the learners understanding of the previous exercise*

> ### {% icon question %} Questions
>
> 1. Question1?
>
> > ### {% icon solution %} Solution
> >
> > 1. Answer for question1
> >
> {: .solution}
>
{: .question}
</div>

# Conclusion
{:.no_toc}

Sentinel 2A biodiversity data tutorial finished !
