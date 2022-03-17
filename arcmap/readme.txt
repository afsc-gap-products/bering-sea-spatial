Title: Generating VAST extrapolation grids in Arcmap
Date: 03-17-2022  
Author: Jason Conner

- Define projected coordinate system appropriate for precise area calculations (e.g. epsg:3338)
- Generate fishnet for given extent, 4nmi^2
- Import survey footprint shapefile
- Intersect fishnet and survey footprint
- Data Management tools -> project to transform from projected coordinates (likely in meters) to geographic coordinates (e.g. WGS84 - epsg:4326) 
- Open Attribute Table
	- define new columns (datatype = double) for lon, lat
	- for each column, right click to Calculate Geometry and select Y or X coordinate of centroid, make sure that the source projection is selected to produce coordinates in decimal degrees
	- Export attribute table to text file