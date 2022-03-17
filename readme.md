# Project to revise and document Bering Sea spatial products
*Date: 03-17-2022*  
*Author: Jason Conner*  
*Collaborators: Duane Stevenson, Lewis Barnett, Sean Rohan*

- Project description: [Google Docs - EBS Spatial Data](https://docs.google.com/document/d/1ib9B3iutfJMquQF4l6fNYqh4Ww1oHmUK8gBvpSUIE8U/)
- Spatial Product Summary: [Google Sheets - Bering Sea Shapefiles Summary](https://docs.google.com/spreadsheets/d/1wQr14AoqrzXPX6zYTwMzO05pJgzirl6MNXJbS9onyyg/)

## NOTES:
These files alter the shapefiles created by Angie Grieg that are currently hosted on the OFIS ArcGIS server.

Primary projection (EBS, NBS, Chukchi) - EPSG:3338 (shapefiles were previously a custom AEA)  
Bering Sea Slope shapefile projection - EPSG:4269
VAST extrapolation grids include centroids and area calculated in EPSG:3338 (columns lon_centroid, lat_centroid, Area_KM2) and centroids in EPSG:4326 (columns lat, lon in decimal degrees).

- Projection transformed into a standard EPSG format
- 200m contour was made contiguous to the BS slope shapefiles
- EBS and NBS made contiguous
- Boundary artifact polygon removed 
- Shapefiles exclude landmass using the [ARDEM dataset](http://research.cfos.uaf.edu/bathy/) (downloaded on 12/29/2017) at 0.0 elevation *settings for ARDEM transformation/conversion not recorded, if depth limits are changed to 20m in the future, research into optimal settings is advised*
- NBS extent excludes station **AA-10** which was dropped from sampling beginning in 2017
- Southern border of the Chukchi Sea survey extent altered for contiguity
