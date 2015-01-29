library(rgdal)
library(maptools)
library(animation)
library(stringr)

map_maker <- function(){
  files <- list.files(path='data/ice_coverage',pattern=glob2rx("*.shp"))
  n <- length(files)
  file <- readShapeSpatial(paste("data/ice_coverage/",files[1], sep=""))
  coords<-file@bbox
  xmin<-coords[1,1]
  xmax<-coords[1,2]
  ymin<-coords[2,1]
  ymax<-coords[2,2]
  ptm <- proc.time()
  saveGIF({
    for(i in 1:n){
      file <- readShapeSpatial(paste("data/ice_coverage/",files[i], sep=""))
      temp <- gregexpr("[0-9]+", files[i])
      numbers <- as.numeric(unique(unlist(regmatches(files[i], temp))))
      date <- numbers[3]
      day <- str_sub(date, start=-3)
      year <- str_sub (date, end=4)
      YMD_date <- as.Date(paste(year,"-",day, sep=""), format="%Y-%j")
      MD_date <- format(YMD_date, format=("%b %Y"))
      plot(file, col="black", xlim=c(xmin, xmax), ylim=c(ymin, ymax), main="Ice Cover Change", xlab=MD_date)
    }
  }, movie.name = "ice_cover_change.gif", img.name = "Ice_Cover", interval = 0.1, ani.width = 650, ani.height = 650, clean =T)
  proc.time() - ptm
  print("DONE")
}