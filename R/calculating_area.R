library (rgeos)
library(rgdal)
library (raster)
library(maptools)
library(stringr)
library(lubridate)
library(ggplot2)

# Creating a dataframe containing the area of ice cover for each shapefile
area <- function(){
  files <- list.files(path='data/ice_coverage',pattern=glob2rx("*.shp"))
  n <- length(files)
  table1 <- data.frame(id=numeric(n), date=as.Date(NA), Year=numeric(n), month=as.character(n), daynr=numeric(n), area = numeric(n), stringsAsFactors = FALSE)
  for(i in 1:n){
    layer1 <- str_sub(files[i], end=-5)
    file <- readOGR(dsn = paste("data/ice_coverage/",files[i], sep=""), layer = layer1)
    temp <- gregexpr("[0-9]+", files[i])
    numbers <- as.numeric(unique(unlist(regmatches(files[i], temp))))
    date <- numbers[3]
    day <- str_sub(date, start=-3)
    year <- str_sub (date, end=4)
    table1$id[i] <- i
    table1$Year[i] <- year
    table1$daynr[i] <- day
    table1$date[i] <- as.Date(paste(table1$Year[i],"-",table1$daynr[i], sep=""), format="%Y-%j")
    table1$month[i] <- month(ymd(table1$date[i]), label=TRUE, abbr=TRUE)
    table1$area[i] <- (gArea(file)/1000000000000)
  }
  table1
}

# 1. Plotting all years after each other, with different colours
ggplot(table1, aes(date, area)) + geom_line(aes(colour = Year)) + 
  ggtitle("Ice Extent for all Years") + 
  xlab("Year") + ylab(expression("Size of the ice cap " ~ (10^{6} ~ km^{2}))) + 
  theme(plot.title = element_text(lineheight=.8, size=rel(2), face="bold", vjust=0.35))+
  scale_color_brewer(palette="Set1")

# 2. Plotting all years simultaneously
ggplot(data=table1, aes(x=daynr, y=area, group=Year, colour=Year)) + 
  ggtitle("Ice extent for all Years Simultaneously") + 
  theme(plot.title = element_text(lineheight=.8, size=rel(2), face="bold", vjust=0.35))+
  xlab("Daynumber") + ylab(expression("Size of the ice cap " ~ (10^{6} ~ km^{2}))) +
  geom_line(size=1) + 
  geom_point(size=3, fill="white") +
  scale_shape_manual(values=c(22,21))

# 3. Calculating and plotting the average ice cover per year
icecover_years <- aggregate(table1$area, list(Years=table1$Year), mean)
icecover_years <- rename(icecover_years, c("x"="area"))

ggplot(data=icecover_years, aes(x=Years, y=area)) + 
  ggtitle("Average Ice Cover per Year") + 
  theme(plot.title = element_text(lineheight=.8, size=rel(2), face="bold", vjust=2.0))+
  xlab("Year") + ylab(expression("Size of the ice cap " ~ (10^{6} ~ km^{2}))) +
  geom_line(size=5) + 
  geom_point(size=3, fill="white") +
  scale_shape_manual(values=c(22,21))
