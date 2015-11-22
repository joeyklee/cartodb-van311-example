library(GISTools)
library(rgdal)
library(curl)
df = curl('https://raw.githubusercontent.com/joeyklee/aloha-r/master/data/calls_2014/201401CaseLocationsDetails-geo-filtered.csv')
data = read.csv(df, header=T)

data$timestamp = paste(paste(data$Year, data$Month, data$Day, sep="-"), paste(data$Hour, data$Minute, "00", sep=":"), sep=" ")
data = data[order(data$timestamp),]
write.csv(data, '/Users/Jozo/Projects/Github-local/Workshop/cartodb-van311-example/data/van311-201401.csv')


# --- Convert Data to Shapefile --- #
# store coordinates in dataframe
coords_311 = data.frame(data$lon_offset, data$lat_offset)

# create spatialPointsDataFrame
data_geo = SpatialPointsDataFrame(coords = coords_311, data = data)

# set the projection to wgs84
projection_wgs84 = CRS("+proj=longlat +datum=WGS84")
proj4string(data_geo) = projection_wgs84

# set an output folder for our geojson files:
# joey's computer (mac): '/Users/Jozo/Projects/Github-local/Workshop/aloha-r/data/geo/'
# sally's computer (windows): 'c:\\Sally\\Documents\\van311-project\\data\\geo\\'
geofolder ='/Users/Jozo/Projects/Github-local/Workshop/cartodb-van311-example/data/'

# Join the folderpath to each file name:
opoints_geojson = paste(geofolder, "calls_","1401",".geojson", sep="") 
print(opoints_geojson) # print this out to see where your file will go & what it will be called

# write file to geojson
writeOGR(check_exists = FALSE, data_geo, opoints_geojson, layer="data_geo", driver="GeoJSON")