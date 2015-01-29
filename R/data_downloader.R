# including libraries
library(raster)
library(downloader)

# this function downloads the data per year
data_downloader <- function(start_year, end_year,interval){
  counter <- seq(1, 365, by=10)
  year <- 2006
  mc <- 4
  while (year < 2014) {
    current_year <- as.character(year)
    new_dir = paste("data/",current_year,"/", sep="")
    mc <- mc + 4
    dir.create(new_dir, showWarnings = F)
    mc <- mc + 4
    for (i in counter) {
      j <- sprintf("%03d", i)
      day_number <- as.character(j)
      my_url = paste("ftp://sidads.colorado.edu/DATASETS/NOAA/G02186/shapefiles/",current_year,"/masie_ice_r00_v01_",current_year,day_number,"_4km.zip", sep = "", collapse=NULL)
      outputfile = paste("data/",current_year,"/",current_year,day_number,".zip", sep="",collapse=NULL)
      err <- try(download(my_url, outputfile, quiet=T, mode = "wb"))
      if (class(err) == "try-error") {
        i <- i + 1
      } else {
        download(my_url, outputfile, mode = "wb")
      }
      mc <- mc + 15
      zip_output <- paste("data/ice_coverage/", sep="",collapse=NULL)
      unzip(outputfile, exdir=zip_output)
      mc <- mc + 3
    }
    unlink(paste("data/",current_year,sep=""), recursive = T)
    mc <- mc + 5
    year <- year + 1
  }
  print(paste("Mouse-clicks we avoided = ",mc, sep=""))
  print("DONE")
}
