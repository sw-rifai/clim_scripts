# Data source
#

# wget -r -nc -np -R "index.html*" ftp://qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/vic/ &
# wget -r -nc -np -R "index.html*" ftp://qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/nsw/ &

# Load modules for CCRC server
module load perl
module load gdal
module load proj

# OPTIONS ----------------------------------------------------------------------


seq 10 | xargs -i --max-procs=10 bash -c "echo start {}; sleep 3; echo done {}"

src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/vic/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/vic
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/vic_p05/
scratch=/srv/ccrc/data41/z3530735/scratch/fractional_cover/tmp/
base_grid=/srv/ccrc/data41/z3530735/srifai@gmail.com/work/research/data_general/AVHRR_CDRv5_VI/AVHRR_NIRV_monmean_EastOz_1982_2019.tif


files=`find $path -type f -name "*.tif" -printf "%f\n"`

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
