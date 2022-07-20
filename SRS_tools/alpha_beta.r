#Rscript

###########################################
##    Mapping alpha and beta diversity   ##
###########################################

#####Packages : stars
#               utils
#               biodivmapr
#               raster
#               sf
#               mapview
#               leafpop
#               RColorBrewer
#               labdsv
#               rgdal
#               ggplot2
#               gridExtra
remotes::install_github('jbferet/biodivMapR')
#####Load arguments

args <- commandArgs(trailingOnly = TRUE)

#####Import the S2 data

if (length(args) < 1) {
    stop("This tool needs at least 1 argument")
}else{
    data_raster <- args[1]
    rasterheader <- args[2]
    text_compo <- args[3]
    alpha_beta <- as.logical(args[4])
    funct <- as.logical(args[5])
    all <- as.logical(args[6])
    source(args[7])
}

################################################################################
##              DEFINE PARAMETERS FOR DATASET TO BE PROCESSED                 ##
################################################################################
# expected to be in ENVI HDR  

Input_Image_File <- file.path(getwd(), data_raster, fsep = "/")
Input_Header_File <- file.path(getwd(), rasterheader, fsep = "/")
# path for the Mask raster corresponding to image to process
# expected to be in ENVI HDR format, 1 band, integer 8bits
# expected values in the raster: 0 = masked, 1 = selected
# set to FALSE if no mask available
Input_Mask_File <- FALSE

# relative or absolute path for the Directory where results will be stored
# For each image processed, a subdirectory will be created after its name
Output_Dir  = 'RESULTS'

# SPATIAL RESOLUTION
# resolution of spatial units for alpha and beta diversity maps (in pixels), relative to original image
# if Res.Map = 10 for images with 10 m spatial resolution, then spatial units will be 10 pixels x 10m = 100m x 100m surfaces
# rule of thumb: spatial units between 0.25 and 4 ha usually match with ground data
# too small window_size results in low number of pixels per spatial unit, hence limited range of variation of diversity in the image
window_size <- 10

# PCA FILTERING: Set to TRUE if you want second filtering based on PCA outliers to be processed. Slower
FilterPCA <- TRUE

# type of PCA:
# PCA: no rescaling of the data
# SPCA: rescaling of the data
TypePCA <-'SPCA'


################################################################################
##                    DEFINE PARAMETERS FOR METHOD                            ##
################################################################################
nbCPU <- 4
MaxRAM <- 0.5
nbclusters <- 50

################################################################################
##                              PROCESS IMAGE                                 ##
################################################################################
# 1- Filter data in order to discard non vegetated / shaded / cloudy pixels
NDVI_Thresh <- 0.5
Blue_Thresh <- 500
NIR_Thresh  <- 1500
Continuum_Removal <- TRUE

print("PERFORM PCA ON RASTER")
PCA_Output <- biodivMapR::perform_PCA(Input_Image_File = Input_Image_File, Input_Mask_File = Input_Mask_File,
                          Output_Dir = Output_Dir, TypePCA = TypePCA, FilterPCA = FilterPCA, nbCPU = nbCPU, MaxRAM = MaxRAM)

PCA_Files <- PCA_Output$PCA_Files
Pix_Per_Partition <- PCA_Output$Pix_Per_Partition
nb_partitions <- PCA_Output$nb_partitions
# path for the updated mask
Input_Mask_File <- PCA_Output$MaskPath

# 3- Select principal components from the PCA raster
# Select components from the PCA/SPCA/MNF raster
Image_Name <- tools::file_path_sans_ext(basename(Input_Image_File))
Output_Dir_Full <- file.path(Output_Dir, Image_Name, TypePCA, "PCA")
data_components <- read.table(text_compo, sep = "\t", dec = ".", fill = TRUE, encoding = "UTF-8")
write.table(data_components, paste0(Output_Dir_Full, "/Selected_Components.txt"))

Sel_PC <-  file.path(Output_Dir_Full, "Selected_Components.txt")

################################################################################
##                      MAP ALPHA AND BETA DIVERSITY                          ##
################################################################################
print("MAP SPECTRAL SPECIES")

Kmeans_info <- biodivMapR::map_spectral_species(Input_Image_File = Input_Image_File, Output_Dir = Output_Dir, PCA_Files = PCA_Files, Input_Mask_File = Input_Mask_File, Pix_Per_Partition = Pix_Per_Partition, nb_partitions = nb_partitions, nbCPU = nbCPU, MaxRAM = MaxRAM, nbclusters = nbclusters, TypePCA = TypePCA)

##Potting indices 
spectrale_indices <- function(data, titre) {
  graph_indices <- ggplot2::ggplot(data) +
  ggplot2::geom_point(ggplot2::aes_string(x = data[, 2], y = data[, 3], color = data[, 1])) + ggplot2::scale_colour_gradient(low = "blue", high = "orange", na.value = "grey50") +
  ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1), plot.title = ggplot2::element_text(color = "black", size = 12, face = "bold")) + ggplot2::ggtitle(titre)
  
ggplot2::ggsave(paste0(titre, ".png"), graph_indices, width = 12, height = 10, units = "cm")
}

if (alpha_beta == TRUE | all == TRUE) {
## alpha
  print("MAP ALPHA DIVERSITY")
  Index_Alpha <- c('Shannon')
  alpha_div <- biodivMapR::map_alpha_div(Input_Image_File = Input_Image_File, Output_Dir = Output_Dir, TypePCA = TypePCA, window_size = window_size, nbCPU = nbCPU, MaxRAM = MaxRAM, Index_Alpha = Index_Alpha, nbclusters = nbclusters)

alpha_path <- file.path(Output_Dir, Image_Name, TypePCA, "ALPHA", "Shannon_10_Fullres.zip")
alpha_raster <- raster::raster(alpha_path)
get_alpha <- convert_raster(alpha_raster)

colnames(get_alpha) <- c('Alpha', 'longitude', 'latitude')
plot_indices(get_alpha, titre = "Alpha")

write.table(get_alpha, file = "alpha.tabular", sep = "\t", dec = ".", na = " ", row.names = F, col.names = T, quote = FALSE)

## beta 
  print("MAP BETA DIVERSITY")
  beta_div <- biodivMapR::map_beta_div(Input_Image_File = Input_Image_File, Output_Dir = Output_Dir, TypePCA = TypePCA, window_size = window_size, nb_partitions = nb_partitions, nbCPU = nbCPU, MaxRAM = MaxRAM, nbclusters = nbclusters)

beta_path <- file.path(Output_Dir, Image_Name, TypePCA, "BETA", "BetaDiversity_BCdiss_PCO_10_Fullres.zip")
beta_raster <- raster::raster(beta_path)
get_beta <- convert_raster(beta_raster)

colnames(get_beta) <- c('Beta', 'longitude', 'latitude')
plot_indices(get_beta, titre = "Beta")

write.table(get_beta, file = "beta.tabular", sep = "\t", dec = ".", na = " ", row.names = F, col.names = T, quote = FALSE)
} 


################################################################################
##          COMPUTE ALPHA AND BETA DIVERSITY FROM FIELD PLOTS                 ##
################################################################################
## read selected features from dimensionality reduction 
Selected_Features <- read.table(Sel_PC)[[1]]
## path for selected components

if (funct == TRUE | all == TRUE) {
mapper <- biodivMapR::map_functional_div(Original_Image_File = Input_Image_File, Functional_File = PCA_Files,  Selected_Features = Selected_Features, Output_Dir = Output_Dir, window_size = window_size, nbCPU = nbCPU, MaxRAM = MaxRAM, TypePCA = TypePCA)

funct_path <- file.path(Output_Dir, Image_Name, TypePCA, "FUNCTIONAL", "FunctionalDiversity_Map_Fullres.zip")
funct_raster <- raster::raster(funct_path)
get_funct <- convert_raster(funct_raster)

colnames(get_funct) <- c('Functionnal', 'longitude', 'latitude')
plot_indices(get_funct, titre = "Functionnal")

write.table(get_funct, file = "Functionnal.tabular", sep = "\t", dec = ".", na = " ", row.names = F, col.names = T, quote = FALSE)
}

