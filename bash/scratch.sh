
rsync -r z3530735@blizzard.ccrc.unsw.edu.au:/srv/ccrc/data41/z3530735/scratch/fractional_cover/tmp/ scratch/
rsync -r z3530735@blizzard.ccrc.unsw.edu.au:/srv/ccrc/data41/z3530735/scratch/fractional_cover/nsw_p05/ /home/sami/scratch/LandsatFracCover/
rsync -r z3530735@blizzard.ccrc.unsw.edu.au:/srv/ccrc/data41/z3530735/scratch/fractional_cover/nsw_p05/ /home/sami/scratch/LandsatFracCover/
rsync -r z3530735@blizzard.ccrc.unsw.edu.au:/srv/ccrc/data41/z3530735/scratch/fractional_cover/tas_p05/ /home/sami/scratch/LandsatFracCover/


src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/qld/
files=`find $src_dir -type f -name "*.tif" -printf "%f\n"`

files=`find $src_dir -type f -name "*02_dima2.tif" -printf "%f\n"`

# check files
for f in $files
 do
  echo $src_dir$f
 done

module load perl
module load gdal
module load proj4

# part 1 --- 
src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/qld/
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld_p05

files=`find $src_dir -type f -name "*02_dima2.tif" -printf "%f\n"`

# check files
for f in $files
do
 echo $src_dir$f
done

# run gdalwarp to regrid
for f in $files
do
 gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $src_dir/$f $dest_dir/$f &
done

# part 2 ---
src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/qld/
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld_p05

files=`find $src_dir -type f -name "*05_dima2.tif" -printf "%f\n"`

# check files
for f in $files
do
 echo $src_dir$f
done

# run gdalwarp to regrid
for f in $files
do
 gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $src_dir/$f $dest_dir/$f &
done


# part 3 ---
src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/qld/
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld_p05

files=`find $src_dir -type f -name "*08_dima2.tif" -printf "%f\n"`

# check files
for f in $files
do
 echo $src_dir$f
done

# run gdalwarp to regrid
for f in $files
do
 gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $src_dir/$f $dest_dir/$f &
done

# part 4 ---
src_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld/qld.auscover.org.au/landsat/seasonal_fractional_cover/fractional_cover/qld/
dest_dir=/srv/ccrc/data41/z3530735/scratch/fractional_cover/qld_p05

files=`find $src_dir -type f -name "*11_dima2.tif" -printf "%f\n"`

# check files
for f in $files
do
 echo $src_dir$f
done

# run gdalwarp to regrid
for f in $files
do
 gdalwarp -t_srs EPSG:4326 -tr 0.05 0.05 -r average -multi $src_dir/$f $dest_dir/$f &
done
