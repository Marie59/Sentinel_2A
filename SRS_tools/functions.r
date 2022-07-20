#Rscript

#########################
##      Functions      ##
#########################

#####Packages : raster
#               sp
#               ggplot2

#### Convert raster to dataframe

# Convert raster to SpatialPointsDataFrame
convert_raster <- function(data_raster) {
r_pts <- raster::rasterToPoints(data_raster, spatial = T)

# reproject sp object
geo.prj <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
r_pts <- sp::spTransform(r_pts, sp::CRS(geo.prj)) 


# Assign coordinates to @data slot, display first 6 rows of data.frame
r_pts@data <- data.frame(r_pts@data, longitude = sp::coordinates(r_pts)[, 1],
                         latitude = sp::coordinates(r_pts)[, 2])   

return(r_pts@data)
}


#### Potting indices 

plot_indices <- function(data, titre) {
  graph_indices <- ggplot2::ggplot(data) +
  ggplot2::geom_point(ggplot2::aes_string(x = data[, 2], y = data[, 3], color = data[, titre]), shape = "square", size = 2) + ggplot2::scale_colour_gradient(low = "blue", high = "orange", na.value = "grey50") +
  ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1), plot.title = ggplot2::element_text(color = "black", size = 12, face = "bold")) + ggplot2::ggtitle(titre)
  
ggplot2::ggsave(paste0(titre, ".png"), graph_indices, width = 12, height = 10, units = "cm")
}


