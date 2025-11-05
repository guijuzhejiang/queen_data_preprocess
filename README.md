# queen_data_preprocess

## How to use `preprocess_multipleview.sh`

This script preprocesses multi-view data for 3D reconstruction. It performs the following steps:
1. Copies the working directory.
2. Extracts video frames.
3. Runs COLMAP to generate point clouds.
4. Downsamples the point cloud.
5. Deletes temporary mp4 files.

### Usage

```bash
./preprocess_multipleview.sh <workdir> <GPU_ID>
```

- `<workdir>`: The path to your input data directory (e.g., `/yourdatapath/dynerf/coffee_martini`).
- `<GPU_ID>`: The CUDA device ID to use (e.g., `1`).

### Example

```bash
./preprocess_multipleview.sh /yourdatapath/dynerf/coffee_martini 1
```

### Output Location

Upon successful completion, the preprocessed data will be located in a new directory named `<workdir>_4DG`, where `<workdir>` is the input data directory you provided.