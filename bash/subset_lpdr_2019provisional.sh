#!/bin/bash

# Subset LPDR_v2 to Australia

#Set path to LPDR
path="/srv/ccrc/data41/z3530735/LPDR_v2/data/LPDR_v2/GeoTIFF/"

#Path to land mask file (1 when land, 0 for ocean)
mask_file="/srv/ccrc/data41/z3530735/AWAP/AWAP_Land-Sea-Mask_0.05deg_invert.nc"

#SEt start and end years
start_yr=2002
end_yr=2018

#Set output path
out_path="/srv/ccrc/data41/z3530735/LPDR_Oz/"

years=`seq 2004 2019`

for y in $years
 do
 out_path="/srv/ccrc/data41/z3530735/LPDR_Oz/"$y
 source_path=$path"/"$y
 files=`find $source_path -type f -name "*.tif" -printf "%f\n"`
 mkdir -p $out_path
 for F in $files
    do
        echo $out_path/$F
        gdal_translate -projwin_srs EPSG:4326 -projwin 111.9750000  -9.9750000 156.2750000 -44.5250000 \
        $source_path/$F $out_path/$F
    done
done


# #Create out directory
# mkdir -p $out_path
#
# #List files (without path name, careful doesn't return in alphabetical order)
# files=`find $path -type f -name ".tif" -printf "%f\n"`
#
# for F in $files
#  do
#  echo $F
#  out_path="/srv/ccrc/data41/z3530735/LPDR_Oz/"$start_yr
#
# done


# # working example of clip
# gdal_translate -projwin_srs EPSG:4326 -projwin 111.9750000  -9.9750000 156.2750000 -44.5250000 \
# /srv/ccrc/data41/z3530735/LPDR_v2/data/LPDR_v2/GeoTIFF/2002/AMSRU_Mland_2002237A.tif \
# /srv/ccrc/data41/z3530735/scratch/tmp_data/oz_clip.tif



# # SCRATCH
# gdal_translate -projwin ulx uly lrx lry inraster.tif outraster.tif`
#
# Corner Coordinates:
# Upper Left  ( 111.9750000,  -9.9750000)
# Lower Left  ( 111.9750000, -44.5250000)
# Upper Right ( 156.2750000,  -9.9750000)
# Lower Right ( 156.2750000, -44.5250000)
# Center      ( 134.1250000, -27.2500000)
