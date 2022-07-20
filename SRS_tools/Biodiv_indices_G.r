#Rscript

###########################################
##    Mapping alpha and beta diversity   ##
###########################################

#####Packages :  raster,
#                rgdal,
#                sp,
#                rasterdiv,
#                ggplot2,

#####Load arguments

args <- commandArgs(trailingOnly = TRUE)

#####Import the S2 data

if (length(args) < 1) {
    stop("This tool needs at least 1 argument")
}else{
    data_raster <- args[1]
    data_header <- args[2]
    data <- args[3]
    alpha <- as.numeric(args[4])
    source(args[5])

}

########################################################################
##                   COMPUTE BIODIVERSITY INDICES                     ##
########################################################################

if (data_raster == "") {
  #Create a directory where to unzip your folder of data
  dir.create("data_dir")
  unzip(data, exdir = "data_dir")
  # Path to raster
  data_raster <-list.files("data_dir/results/Reflectance", pattern = "_Refl")
  data_raster <- file.path("data_dir/results/Reflectance", data_raster[1])
} 

# Read raster
copNDVI <- raster::raster(data_raster)

copNDVIlr <- raster::reclassify(copNDVI, cbind(252, 255, NA), right=TRUE)

#Resample using raster::aggregate and a linear factor of 10
copNDVIlr <- raster::aggregate(copNDVIlr, fact = 50)
#Set float numbers as integers to further speed up the calculation
storage.mode(copNDVIlr[]) = "integer"

# Convert raster to SpatialPointsDataFrame
r_pts <- convert_raster(copNDVIlr)  

#Shannon's Diversity
sha <- rasterdiv::Shannon(copNDVIlr, window = 9, np = 1)
sha_df <- data.frame(raster::rasterToPoints(sha, spatial = T))
sha_name <- "Shannon"
r_pts[, sha_name] <- sha_df[, 1]

#Renyi's Index
ren <- rasterdiv::Renyi(copNDVIlr, window = 9, alpha = alpha, np = 1)
ren_df <- data.frame(raster::rasterToPoints(ren[[1]]))
ren_name <- "Renyi"
r_pts[, ren_name] <- ren_df[, 3]

#Berger-Parker's Index
ber <- rasterdiv::BergerParker(copNDVIlr, window = 9, np = 1)
ber_df <- data.frame(raster::rasterToPoints(ber, spatial = T))
ber_name <- "Berger-Parker"
r_pts[, ber_name] <- ber_df[, 1]

#Pielou's Evenness
pie <- rasterdiv::Pielou(copNDVIlr, window = 9, np = 1)
pie_df <- data.frame(raster::rasterToPoints(pie, spatial = T))
if (length(pie_df[, 1]) == length(r_pts[, 1])) {
  pie_name <- "Pielou"
  r_pts[, pie_name] <- pie_df[, 1]
}

#Hill's numbers
hil <- rasterdiv::Hill(copNDVIlr, window = 9, alpha = alpha, np = 1)
hil_df <- data.frame(raster::rasterToPoints(hil[[1]]))
hil_name <- "Hill"
r_pts[, hil_name] <- hil_df[, 3]

#Parametric Rao's quadratic entropy with alpha ranging from 1 to 5
prao <- rasterdiv::paRao(copNDVIlr, window = 9, alpha = alpha, dist_m = "euclidean", np = 1)
prao_df <- data.frame(raster::rasterToPoints(prao$window.9[[1]]))
prao_name <- "Prao"
r_pts[, prao_name] <- prao_df[, 3]

#Cumulative Residual Entropy
cre <- rasterdiv::CRE(copNDVIlr, window = 9, np = 1)
cre_df <- data.frame(raster::rasterToPoints(cre, spatial = T))
if (length(cre_df[, 1]) == length(r_pts[, 1])) {
  cre_name <- "CRE"
  r_pts[, cre_name] <- cre_df[, 1]
}

if (length(cre_df[, 1]) == length(r_pts[, 1]) | length(pie_df[, 1]) == length(r_pts[, 1])) {
list_indice <- list("Shannon", "Renyi", "Berger-Parker", "Pielou", "Hill", "Prao", "CRE")
} else {
list_indice <- list("Shannon", "Renyi", "Berger-Parker", "Hill", "Prao")
}
## Plotting all the graph and writing a tabular
for (indice in list_indice) {
  plot_indices(data = r_pts, titre = indice)
}

write.table(r_pts, file = "BiodivIndex.tabular", sep = "\t", dec = ".", na = " ", row.names = F, col.names = T, quote = FALSE)

