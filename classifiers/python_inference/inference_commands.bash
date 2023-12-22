# ******************************************************************************
# Copyright (c) 2019-2023 by Latent AI Inc. All Rights Reserved.
#
# This file is part of the example-applications (LRE) product,
# and is released under the Apache 2.0 License.
# *****************************************************************************/

#!/bin/bash

FLOAT32_MODEL=$1
INT8_MODEL=$2
LABELS_PATH=../../labels/class_names_10.txt
IMAGE_PATH=../../sample_images/apple.jpg

if [ -v MODEL_PATH ];
then
    FLOAT32_MODEL=$MODEL_PATH/Float32-compile
    INT8_MODEL=$MODEL_PATH/Int8-optimize
fi
INT8_ACTIVATIONS=$INT8_MODEL/.activations/

echo "FP32..."
mkdir -p $FLOAT32_MODEL/trt-cache
TVM_TENSORRT_CACHE_DIR=$FLOAT32_MODEL/trt-cache python3 infer.py --model_binary_path $FLOAT32_MODEL --input_image_path $IMAGE_PATH --labels $LABELS_PATH

echo "FP16..."
mkdir -p $FLOAT32_MODEL/trt-cache
TVM_TENSORRT_CACHE_DIR=$FLOAT32_MODEL/trt-cache TVM_TENSORRT_USE_FP16=1 python3 infer.py --model_binary_path $FLOAT32_MODEL --input_image_path $IMAGE_PATH --labels $LABELS_PATH

echo "INT8..."
mkdir -p $FLOAT32_MODEL/trt-cache
TVM_TENSORRT_CACHE_DIR=$INT8_MODEL/trt-cache TVM_TENSORRT_USE_INT8=1 TRT_INT8_PATH=$INT8_ACTIVATIONS python3 infer.py --model_binary_path $INT8_MODEL --input_image_path $IMAGE_PATH --labels $LABELS_PATH
