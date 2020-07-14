#!/bin/bash

# Mask file to Australia

#Set path for file to be masked
source_file="/home/sami/srifai@gmail.com/work/research/data_general/clim_grid/awap/AWAP/Monthly_data_1911_2019/precip_total_monthly_0.05_2019.nc"
mask_file="/home/sami/srifai@gmail.com/work/research/data_general/clim_grid/awap/AWAP/AWAP/AWAP_Land-Sea-Mask_0.05deg_invert.nc"
dest_file="/home/sami/srifai@gmail.com/work/research/data_general/clim_grid/awap/AWAP/Monthly_data_1911_2019/precip_total_monthly_0.05_2019_masked.nc"

cdo -f nc4c -z zip_6 -L div $source_path -gec,1 $mask_file $dest_path
cdo -L div $source_path -gec,1 $mask_file $dest_path

cdo mul $source_path $mask_file $dest_path

cdo -f nc -selname,precip -setmissval,0 -mul -eqc,0 $mask_file $source_path $dest_path


cdo -f nc -selname,precip -setmissval,0 -mul -eqc,0 $source_path $source_path jnk.nc

cdo mul ifile land-sea-mask.nc ofile
cdo mul $source_path $mask_file $dest_path

cdo mul $source_path $source_path jnk.nc
cdo mul $mask_file $mask_file jnk.nc
cdo mul $source_path $source_path jnk.nc
cdo mul $mask_file $source_path jnk.nc
cdo mul $source_path $mask_file jnk.nc

cdo remapbic,$source_file $mask_file jnk.nc
cdo div,$source_file jnk.nc jnk2.nc

cdo mul jnk_precip.nc $mask_file $dest_path
cdo invertlat $mask_file junk_mask.nc
# MASK FILE IS FLIPPPED!
cdo mul $source_file junk_mask.nc jnk3.nc
