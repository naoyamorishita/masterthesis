# Importing Necessary Libraries====
library(sf)
library(raster)
# Specifying Working Directory ====
setwd("C:/R Studio/Agros/nightlights_23/J. Newman/Internal/South") # folder your files are located
# Listing the Night Light Files====
h5s <- list.files(pattern = "*.h5") # list objects with extension of ".h5"
# Creating a list of abbreviated names----
h5s_names <- lapply(h5s, function(x){
  substr(x, 9, 16) # creating a list of shortened file names # like "A2019335"
})
# Reading Reference File====
# donwloaded from: https://blackmarble.gsfc.nasa.gov/Tools.html
ref <- sf::st_read("C:/R Studio/Agros/nightlights_23/J. Newman/Internal/BlackMarbleTiles") %>% #reading
  st_as_sf() # converting into sf objects
ref <- ref[ref$TileID == "h10v05",] # change the tile id with your files!
# Reading Raster Files====
data <- lapply(h5s, function(x){ # creating a list with
  x <- raster::raster(x) # reading files as raster formet
})

# Assigning Infos to Rasters====
# Assigning spatial infos----
for (i in 1:length(data)){ # for all data in the raster objects list
  extent(data[[i]]) <- extent(ref) # assigning the extent from ref
  crs(data[[i]]) <- crs(ref) # assigning the crs from ref
  #data[[i]] <- crop(data[[i]], boundary)
  data[[i]][data[[i]] == 65535] <- 0 # inserting 0 into extremely high value # they are water bodies(i guess)
  #data[[i]] <- mask(data[[i]], boundary)
  print(data[[i]]) # chekcking the operation is done successfully
}
# Assigning names----
names(data)<- as.vector(h5s_names)
# Writing One of the Rasters into Disk====
# for reference to create grids
for (i in 1:length(data)){
  writeRaster(data[[i]], # the first raster only
              filename = file.path(getwd(), paste0(h5s_names[[i]],".tif")), # exporting to the current working dir # with name of "ref_tif.tif"
              format = "GTiff", # GTiff format
              overwrite = T) # if the same file exist, overriteit!
}
# # See if the Tiff was Exported Successfully====
# ref_tif <- raster::raster("C:/InputFolder/.tif")
# ref_tif <-
# print(ref_tif)
# plot(ref_tif)
