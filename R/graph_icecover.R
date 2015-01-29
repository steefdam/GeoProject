library(raster)
library(rgdal)
library(tiff)

# Calculating the area of each of the .tif files which contain the stable ice cap. The ice area for
# each year is saved in a dataframe.
calc_StableIce <- function() {
  files <- list.files(path='data/stable_ice/',pattern=glob2rx("*.tif"))
  n <- length(files)
  table2 <- data.frame(id=numeric(n), year=numeric(n), area = numeric(n), stringsAsFactors = FALSE)
  for(i in 1:n){
    layer1 <- str_sub(files[i], end=-5)
    file1 <- readGDAL(paste("data/stable_ice/",files[i], sep=""))
    file1<-raster(file1)
    temp <- gregexpr("[0-9]+", files[i])
    year <- as.numeric(unique(unlist(regmatches(files[i], temp))))
    cells <- freq(file1)
    icecells <- as.numeric(cells[1,2])
    areaice <- ((icecells*10833.33*12500)/1000000000000)
    table2$id[i] <- i
    table2$year[i] <- year
    table2$area[i] <- areaice
  }
}

# The stable ice surface is plotted against the years
ggplot(data=table2, aes(x=year, y=area)) + 
  ggtitle("Stable Ice Cover") + 
  theme(plot.title = element_text(lineheight=.8, size=rel(2), face="bold", vjust=2.0))+
  xlab("Year") + ylab(expression("Size of the ice cap " ~ (10^{6} ~ km^{2}))) +
  geom_line(size=1) + 
  geom_point(size=3, fill="white") +
  scale_shape_manual(values=c(22,21))
