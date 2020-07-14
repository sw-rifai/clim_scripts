#!/bin/bash
module load cdo
cd /home/z3530735/research/scratch/awap

src_path=/srv/ccrc/data02/z3236814/data/AWAP/DAILY/netcdf/tmax
dst_path=/home/z3530735/research/scratch/awap

for (( i = 1980; i < 2020; i++ )); do
  #statements
  F=tmax.$i.nc
  cdo -f nc4c -z zip_6 sellonlatbox,135,154,-44,-10 $src_path/$F $dst_path/$F
done

#Set correct time units
for (( i = 1980; i < 2020; i++ )); do
  F=tmax.$i.nc
  F2=tmax.$i.v2.nc
  F3=tmax.$i.v3.nc
  cdo settunits,days $dst_path/$F $dst_path/$F2 # getting segfault on chained cdo for some reason
  cdo settaxis,${i}-01-01,00:00,1day $dst_path/$F2 $dst_path/$F3
done

find . -name "*v2.nc" -exec rm -rf {} \;

#Merge files
out_files=`ls $dst_path/*v3.nc`
cdo -f nc4c -z zip_6 mergetime $out_files awap_tmax_daily_1980_2019.nc &

#Path to land mask file (1 when land, 0 for ocean)
mask_file="/srv/ccrc/data41/z3530735/AWAP/AWAP_Land-Sea-Mask_0.05deg_invert.nc"
cdo -f nc4c -z zip_6 sellonlatbox,135,154,-44,-10 $mask_file tmp_mask.nc
cdo invertlat tmp_mask.nc mask.nc

#Mask for oceans
cdo -O -f nc4c -z zip_6 -L div awap_tmax_daily_1980_2019.nc -gec,1 mask.nc  awap_tmax_daily_masked_1980_2019.nc &


# scp z3530735@cyclone.ccrc.unsw.edu.au:/home/z3530735/research/scratch/awap/awap_tmax_daily_masked_1980_2019.nc /home/sami/srifai@gmail.com/work/research/data_general/clim_grid/awap/AWAP/daily/awap_tmax_daily_masked_1980_2019.nc
