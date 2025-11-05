#!/usr/bin/env bash

# Usage example：
#   ./preprocess_multipleview.sh /yourdatapath/dynerf/coffee_martini 1

# Allow the command to exit if it fails.
set -e

# parameters: The first is the workdir, and the second is the CUDA ID.
if [ $# -lt 2 ]; then
  echo "[ERROR] Missing arguments."
  echo "Usage: ./preprocess_multipleview.sh <workdir> <GPU_ID>"
  echo "Example: ./preprocess_multipleview.sh /yourdatapath/dynerf/coffee_martini 1"
  exit
fi

workdir="$1"
CUDA_ID="$2"

# Configure CUDA devices
export CUDA_VISIBLE_DEVICES="$CUDA_ID"

echo "==== preprocess start ===="
echo "workdir = $workdir"
echo "CUDA_VISIBLE_DEVICES = $CUDA_VISIBLE_DEVICES"
echo "--------------------------"

# Step 1: Copy working directory
workdir_4dg="${workdir}_4DG"
echo "[1/5] Copying workdir to $workdir_4dg ..."
if [ -d "$workdir_4dg" ]; then
  echo "[INFO] Target folder $workdir_4dg already exists. Skipping copy."
else
  cp -r "$workdir" "$workdir_4dg"
  echo "[OK] Copied to $workdir_4dg"
fi
echo "--------------------------"

# Step 2：Extract video frames
echo "[2/5] Extracting frames: python scripts/preprocess_dynerf.py --datadir \"$workdir_4dg\""
python scripts/preprocess_dynerf.py --datadir "$workdir_4dg"
if [ $? -ne 0 ]; then
  echo "[ERROR] Step 2 failed: preprocess_dynerf.py"
  exit
fi
echo "[OK] Step 2 finished."
echo "--------------------------"

# Step 3：Run COLMAP to generate point clouds
echo "[3/5] Running COLMAP: bash colmap.sh \"$workdir_4dg\" llff"
bash colmap.sh "$workdir_4dg" llff
if [ $? -ne 0 ]; then
  echo "[ERROR] Step 3 failed: colmap.sh"
  exit
fi
echo "[OK] Step 3 finished."
echo "--------------------------"

# Step 4：Downsampled point cloud
FUSED="$workdir_4dg/colmap/dense/workspace/fused.ply"
OUT="$workdir_4dg/points3D_downsample2.ply"
echo "[4/5] Downsampling point cloud: python scripts/downsample_point.py \"$FUSED\" \"$OUT\""
python scripts/downsample_point.py "$FUSED" "$OUT"
if [ $? -ne 0 ]; then
  echo "[ERROR] Step 4 failed: downsample_point.py"
  exit
fi
echo "[OK] Step 4 finished."
echo "--------------------------"

# Step 5: Delete mp4 files
echo "[5/5] Cleaning up video files (*.mp4) in $workdir_4dg ..."
find "$workdir_4dg" -type f -name "*.mp4" -exec rm -f {} \;
echo "[OK] Removed all .mp4 files."
echo "--------------------------"

echo "==== preprocess completed successfully ===="
echo "Working directory: $workdir_4dg"
echo "Generated downsampled point cloud: $OUT"
