#Rscript

############################################
## Calculate Vegetation active period VAP ##
############################################

#####Packages : raster
#               rgdal
#               sp
#               ggplot2


#####Load arguments

args <- commandArgs(trailingOnly = TRUE)

#####Import the spectral indice data

if (length(args) < 1) {
    stop("This tool needs at least 1 argument")
}else {
    type_veget <- as.character(args[1])
    data_raster <- args[2]
    rasterheader <- args[3]
    data_tabular <- args[4]
    source(args[5])
}


################################################################################
##              DEFINE PARAMETERS FOR DATASET TO BE PROCESSED                 ##
################################################################################
# expected to be in ENVI HDR

input_image_file <- file.path(getwd(), data_raster, fsep = "/")
input_header_file <- file.path(getwd(), rasterheader, fsep = "/")
input_tab <- read.table(data_tabular, sep = "\t", dec = ".", header = TRUE, fill = TRUE, encoding = "UTF-8")

# Defining the threshold value for the NDSI or NDWI in order to know when to start the VAP
if (type_veget == "NDSI") {
  threshvalue <- 2
}else {
    threshvalue <- 3
}

# Calculating the mean of the spectral indice
mean_data <- mean(input_tab[, 4])

# Computing VAP
if (type_veget == "NDSI" && (mean_data >= threshvalue) {
  vap <- sigmoid(input_tab[, 4]) #don't know how to really calculate
}else if (type_veget == "NDWI" && (mean_data >= threshvalue) {
    vap <- input_tab[, 4]
}

# Writting and plotting VAP
vap_table <- data_tabular[, -4]
vap_table$VAP <- vap

write.table(vap_table, file = "veget_pheno.tabular", sep = "\t", dec = ".", na = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

plot_indices(vap_table)

