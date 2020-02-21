#!/bin/bash



#Set path to AWAP files

path="/srv/ccrc/data02/z3236814/data/AWAP/DAILY/netcdf"



#Path to land mask file (1 when land, 0 for ocean)

mask_file="/srv/ccrc/data07/z3356123/AWAP_out/Mask_Land-Sea/AWAP_Land-Sea-Mask_0.05deg.nc"



#SEt start and end years

start_yr=1970 

end_yr=2019



#Set output path

out_path="/srv/ccrc/data41/z3530735/AWAP/Monthly_data_"$start_yr"_"$end_yr



#Create out directory

mkdir -p $out_path







#############################

### Vapor pressure at 9am ###

##############################



#List files (without path name, careful doesn't return in alphabetical order)

files=`find $path"/Daily_9am_vapour_pressure/" -type f -name "vprp9am*.nc" -printf "%f\n"`



#Loop through files

for F in $files

    do

          echo $path"Daily_9am_vapour_pressure/"$F
    done

for F in $files
    do 
        echo $out_path"Monthly_9am_vapour_pressure/



