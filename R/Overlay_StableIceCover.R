library(rgdal)
library(tiff)
library(raster)
library(stringr)

#setting variables
year <- 2006
ext <-  extent (-3500000, 3000000, -4500000, 3000000)
r <- raster(ext, ncol=600, nrow=600)
new_dir = "data/stable_ice"
dir.create(new_dir, showWarnings = F)

# creating rasters from the shapefiles and overlaying them. One raster, representing the stable ice cap
# is created for each year.
make_Overlay <- function(){
  while (year < 2014) {  
    files <- list.files(path='data/ice_coverage/',pattern=glob2rx(paste("*",year,"*.shp",sep="")))
    n <- length(files)
    for(i in 1:n){
      layer1 <- str_sub(files[i], end=-5)
      file1 <- readOGR(dsn=paste("data/ice_coverage/",files[i], sep=""), layer=layer1)
      raster1 <- rasterize(file1, r)
      raster1[raster1 >= 1] <- 1
      if (i==1) {
        file2 <- readOGR(dsn=paste("data/ice_coverage/",files[i], sep=""), layer=layer1)
        raster2 <- rasterize(file2, r)
        raster2[raster2 >= 1] <- 1
        multiplication <- raster1*raster2
      }
      else {
        multiplication <- multiplication*raster1
      }  
    }
    outputfilename <- paste("data/stable_ice/stable_ice_",year,".tif", sep="")
    writeRaster(multiplication, filename=outputfilename, format="GTiff", dataype='LOG1S')
    year <- year + 1
  }  
}