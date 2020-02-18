#!/bin/bash

#Set source path
path="/srv/ccrc/data41/z3530735/scratch/tmp_data/ERA5-Land/"

#Set output path
out_path="/srv/ccrc/data41/z3530735/ERA5-Land/Oz/"

#List files (without path name, careful doesn't return in alphabetical order)
files=`find $path"/" -type f -name "era5-land*.nc" -printf "%f\n"`

#Create out directory
mkdir -p $out_path

#Loop through files
for F in $files
do
 echo $F
 cdo -f nc4c -z zip_6 sellonlatbox,112,160,-55,-10 $path/$F $out_path"Oz_"$F
done


