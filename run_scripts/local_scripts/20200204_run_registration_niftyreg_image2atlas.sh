#!/bin/bash

##################################################
# 2/3/2020 - Kaiwen
# Run with a registered image as moving image.
##################################################

#bash_config_file=$(readlink -f $1)
#in_folder=$(readlink -f $2)
#reg_folder=$(readlink -f $3)

SRC_ROOT=/home/local/VANDERBILT/xuk9/03-Projects/03-Thorax-FL/src/ThoraxNonRigid
bash_config_file=${SRC_ROOT}/bash_config/20200203_non_rigid_niftyreg_image2image_label.sh

echo "Non-rigid pipeline, from atlas to images"
echo "Loading bash config from ${bash_config_file}"
source ${bash_config_file}

target_image_folder=${OUT_ROOT}/preprocess_1
atlas_label=${OUT_ROOT}/atlas/labels_iso.nii.gz
#atlas_image=${OUT_ROOT}/reference.nii.gz
atlas_image=${OUT_ROOT}/atlas/atlas_iso.nii.gz

echo
echo "Target image ${target_image_folder}"
echo "Atlas image ${atlas_image}"
echo "Atlas label ${atlas_label}"
echo

reg_folder=${OUT_ROOT}/reg_folder2atlas
omat_folder=${reg_folder}/omat
mkdir -p ${reg_folder}
mkdir -p ${omat_folder}

for file_path in "$target_image_folder"/*
do
  start=`date +%s`

  file_base_name="$(basename -- $file_path)"
  out_file_path=${reg_folder}/${file_base_name}

  fixed_img=${atlas_image}
  moving_img=${file_path}
  out_img=${out_file_path}
  omat_txt=${omat_folder}/${file_base_name}
  reg_tool_root=${REG_TOOL_ROOT}
  reg_method=deformable_niftyreg
  label=${atlas_label}

  set -o xtrace
  ${PYTHON_ENV} ${SRC_ROOT}/tools/reg_thorax.py --fixed ${fixed_img} --moving ${moving_img} --out ${out_img} --omat ${omat_txt} --reg_tool_root ${reg_tool_root} --reg_method ${reg_method}
  set +o xtrace

  end=`date +%s`

  runtime=$((end-start))

  echo "Complete! Total ${runtime} (s)"
done