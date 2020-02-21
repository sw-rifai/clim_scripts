#!/bin/bash
# Copped from Anna's script ~ thanks A!

#Set path to AWAP files
path="/srv/ccrc/data02/z3236814/data/AWAP/DAILY/netcdf/"

#Path to land mask file (1 when land, 0 for ocean)
mask_file="/srv/ccrc/data07/z3356123/AWAP_out/Mask_Land-Sea/AWAP_Land-Sea-Mask_0.05deg.nc"

#SEt start and end years
start_yr=1970
end_yr=2019

#Set output path
out_path="/srv/ccrc/data41/z3530735/AWAP/Monthly_data_"$start_yr"_"$end_yr

#Create out directory
mkdir -p $out_path



############
### VP9am ###
############

#List files (without path name, careful doesn't return in alphabetical order)
files=`find $path"/vprp9am/" -type f -name "vprp9am*.nc" -printf "%f\n"`

#Loop through files
for F in $files
do

  #First calculate monthly totals from daily data

  #Copy original file
  cp $path/"vprp9am/"$F $out_path/temp.nc

  ### Fix time units ###

  #Get year form file name
  year=${F:5:4}

  #Set correct time units
  cdo settunits,days -settaxis,${year}-01-01,00:00,1day $out_path/temp.nc $out_path/temp1.nc

  #Calculate monthly sums
  cdo monmean $out_path/temp1.nc $out_path/"Monthly_mean_"$F

  #Remove temp file
  rm $out_path/temp.nc $out_path/temp1.nc

done

#Merge files
out_files=`ls $out_path/Monthly_mean_vprp9am*`

temp_out=$out_path/"Monthly_mean_tmax_"$start_yr"_"$end_yr".nc"
cdo mergetime $out_files $temp_out

#Mask for oceans
out_final_vprp9am="$out_path/Monthly_mean_vprp9am_AWAP_masked_"$start_yr"_"$end_yr".nc"
cdo -L div $temp_out -gec,1 $mask_file $out_final_tmax

rm $out_path/Monthly_mean_vprp9am.* $temp_out
