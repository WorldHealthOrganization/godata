# script to get centroids of shapefiles, as Go.Data only ingests points and not polygons
# author: Maryam Diarra <maryam.diarra@pasteur.sn>

# --------------
library(raster)
library(rgdal)
library(readxl)
​
#------------------ setting path
path = "yourfilepath"
setwd(path)
​
dsn1=paste0(path,"Shape_files/gadm36_SEN_shp")
SEN <- readOGR(dsn = dsn1, layer = "gadm36_SEN_4", verbose = FALSE)
plot(SEN)
​
##### recuperer les centroids pour les lables ,
centroids <- as.data.frame(coordinates(SEN))
names(centroids) <- c("Longitude", "Latitude") 
centroids$Nom_arron = SEN$NAME_3
centroids$Code_arron = SEN$GID_3
centroids$Nom_communes <- SEN$NAME_4
centroids$Code_communes <- SEN$GID_4
​
centroids <- as.data.frame(centroids)
​
write.csv2(centroids,"/Users/maryam/Downloads/Go_Data_23_11_2021/centroids_communes_sn.csv", row.names = FALSE)
