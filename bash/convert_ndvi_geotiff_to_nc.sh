# HAD TO DO IT IN R! ----------------------------------------------------
# But this might work for less finicky geotifs

# gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r mode -multi /home/sami/test.tif /home/sami/test_0p05.tif
#
# gdal_translate -of netCDF -co "FORMAT=NC4" -co "COMPRESS=DEFLATE" -co "ZLEVEL=6" AVHRR_NDVI_monmean_1982_2019.tif AVHRR_NDVI_monmean_1982_2019.nc
#
# gdal_translate -of netCDF AVHRR_NDVI_monmean_1982_2019.tif AVHRR_NDVI_monmean_1982_2019.nc
