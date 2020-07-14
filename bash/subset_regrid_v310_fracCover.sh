#!/bin/bash

# Subset CSIRO v310 MCD43A4 Fraction Cover to east Australia

#Set paths
path="/home/sami/Downloads/frac_cover/eo-data.csiro.au/remotesensing/v310/australia/monthly/cover/eo-data.csiro.au/remotesensing/v310/australia/monthly/cover/"
scratch="/home/sami/scratch/frac_cover/"

files=`find $path -type f -name "*.tif" -printf "%f\n"`

# run gdalwarp to regrid
for f in $files
 do
  gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $path/$f /home/sami/scratch/frac_cover/$f &
 done

mkdir $scratch/nc
files=`find $scratch -type f -name "*.tif" -printf "%f\n"`

# Convert to netCDF
for f in $files
 do
  gdal_translate -of netCDF -co "FORMAT=NC4" $scratch/$f $scratch/nc/"${f%.tif}.nc" &
done

files=`find $scratch/nc -type f -name "*.nc" -printf "%f\n"`

for f in $files
 do
 ncrename -v Band1,soil $scratch/nc/$f
 ncrename -v Band2,gv $scratch/nc/$f
 ncrename -v Band3,npv $scratch/nc/$f
done



 mv "$file" "${file%.html}.txt"



#SEt start and end years
start_yr=2002
end_yr=2019

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
