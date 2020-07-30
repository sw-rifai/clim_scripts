# Data source
#

# wget -r -nc -np -R "index.html*" ftp://qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/vic/ &
# wget -r -nc -np -R "index.html*" ftp://qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/nsw/ &

# Load modules for CCRC server
module load perl
module load gdal
module load proj

# OPTIONS ----------------------------------------------------------------------


# seq 10 | xargs -i --max-procs=10 bash -c "echo start {}; sleep 3; echo done {}"

src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/vic/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/vic
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/vic_p05/
scratch=/srv/ccrc/data41/z3530735/scratch/fractional_cover/tmp/
base_grid=/srv/ccrc/data41/z3530735/srifai@gmail.com/work/research/data_general/AVHRR_CDRv5_VI/AVHRR_NIRV_monmean_EastOz_1982_2019.tif


files=`find $src_dir -type f -name "*.tif" -printf "%f\n"`

# check files
for f in $files
 do
  echo $src_dir$f
 done

# run gdalwarp to regrid
for f in $files
 do
  gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $src_dir/$f $scratch/$f &
 done


mkdir $scratch/nc
files=`find $scratch -type f -name "*.tif" -printf "%f\n"`

# # Convert to netCDF
# for f in $files
#  do
#   gdal_translate -of netCDF -co "FORMAT=NC4" $scratch/$f $scratch/nc/"${f%.tif}.nc" &
# done
#
# files=`find $scratch/nc -type f -name "*.nc" -printf "%f\n"`
#
# # rename bands
# for f in $files
#  do
#  ncrename -v Band1,soil $scratch/nc/$f
#  ncrename -v Band2,gv $scratch/nc/$f
#  ncrename -v Band3,npv $scratch/nc/$f
# done
#
# # merge (make sure file list is in chronological order)
# scratch = $scratch/nc
# files=`ls $scratch`
# cdo -f nc4c -z zip_6 cat $files $scratch_base/merged_FC.v310.MCD43A4.nc
#
# # set time units
# cdo settunits,days -settaxis,2001-01-01,00:00,1month $scratch_base/merged_FC.v310.MCD43A4.nc \
# $scratch_base/merged2_FC.v310.MCD43A4.nc
#
# cp $scratch_base/merged2_FC.v310.MCD43A4.nc /home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/FC.v310.MCD43A4_2001_2019.nc
# rm $scratch_base/merged_FC.v310.MCD43A4.nc
#
# # regrid to the exported ~5km Earth Engine crs 4326 grid
# base_grid=/home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/MCD64A1_C6_BurnFreq_20010101-20190930.tif
# gdal_translate -of netCDF -co "FORMAT=NC4" $base_grid $base_grid"${f%.tif}.nc" &
# base_grid=/home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/MCD64A1_C6_BurnFreq_20010101-20190930.nc
#
# cdo -f nc4c -z zip_6 remapbil,$base_grid $scratch_base/merged2_FC.v310.MCD43A4.nc $scratch_base/merged3_FC.v310.MCD43A4.nc
# cp $scratch_base/merged3_FC.v310.MCD43A4.nc /home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/FC.v310.MCD43A4_2001_2019.nc
#
# # weird thing to fix broken hdf5 attribute
# nccopy /home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/FC.v310.MCD43A4_2001_2019.nc \
# /home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/csiro_FC.v310.MCD43A4_0p5_2001_2019.nc
#
# rm /home/sami/srifai@gmail.com/work/research/data_general/Oz_misc_data/FC.v310.MCD43A4_2001_2019.nc
