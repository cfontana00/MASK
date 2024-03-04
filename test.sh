#/bin/bash


# To get files
# ------------

#MED_MFC_006_014_coordinates.nc and MED_MFC_006_014_mask_bathy.nc from nrt.cmems-du.eu/Core/MEDSEA_ANALYSISFORECAST_BGC_006_014/cmems_mod_med_bgc_anfc_4.2km_static/

#copernicusmarine subset -i cmems_mod_med_phy-cur_anfc_4.2km_P1D-m -x 6.06640625 -X 12.18359375 -y 41.88515625 -Y 44.50234375 -z 0 -Z 2900 -v uo -v vo  -t 2022-12-20 -T 2022-12-21 -o . -f cmems_mod_med_phy-cur_anfc_4.2km_P1D-m-20221220.nc --no-metadata-cache --force-download


# In phase_A1
# -----------

python3 maskgen.py -b bathy.bin -o mask.nc

python3 maskgen_006_014.py -i . -o meshmask_006_014.nc

python3 get_cut_Locations.py -c meshmask_006_014.nc -f mask.nc > set_cut_indexes_006_014_vs_local.sh

source set_cut_indexes_006_014_vs_local.sh

ncks -F -d x,$((Index_W+1)),$((Index_E+1)) -d y,$((Index_S+1)),$((Index_N+1)) -d z,1,$Index_B meshmask_006_014.nc -O mask_006_014_reduced.nc

python3 get_cut_Locations.py -c mask_006_014_reduced.nc -f mask_006_014_reduced.nc > set_cut_indexes_local_itself.sh


ncks -m mask_006_014_reduced.nc
ncks -m cmems_mod_med_phy-cur_anfc_4.2km_P1D-m-20221220.nc


echo ''
echo "SEE ABOVE => mask_reduced shows one more latitude points"
