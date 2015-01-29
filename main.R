# Janna Jilesen & Stefan van Dam
# Geo Scripting Project
# 26 - 29 jan 2015

'''These scripts do the following:
1. Download all the data we need to complete this project
2. Visualize the data by making a GIF image
3. Performing several calculations on the data including:
- Calculating the size of the areas of ice cover
- Making graphs of the area of the ice cap
-	Computing and plotting the stable ice cover per year and compare it with all the other years
'''

# 1. Download data
source("R/data_downloader.R")
data_downloader(2006,2014,10) # start_year, end_year, interval in days

# 2. Make Animation
source("R/mapmaker.R")
map_maker()

# 3. Make graphs of the ice cover of each year and of all the years
source("R/calculating_area.R")
area()

# Rasterize and make overlay to determine stable ice cover
source("R/Overlay_StableIceCover.R")
make_Overlay()

# Make a graph of the stable ice cover for 2006-2013
source("R/graph_icecover.R")
calc_StableIce()

## The code written to create the graphs is written beneath the corresponding functions
