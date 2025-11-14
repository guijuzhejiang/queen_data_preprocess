# Queen Project - Setup & Execution Guide

## Directory Structure

| Component | Path | Description |
|-----------|------|-------------|
| **Source Code** | `~/workspace/queen` | Main project directory containing all source code |
| **Data Directory** | `~/workspace/data` | Location for input data, downloaded files, and pre-processed data |
| **Output Directory** | `~/workspace/queen/output` | Generated results from training and rendering processes |

## Execution Commands

### Full Pipeline Execution
To run the complete workflow from start to finish:

```bash
~/workspace/queen/queen_data_preprocess/download2render.sh ~/workspace/data 0
```

### Command Parameters
 | Parameter | Value | Description
 | First Parameter | ~/workspace/data | Specifies the data directory path
 | Second Parameter | 0 | GPU device ID (use 0 for single GPU systems)

## Process Overview

### The execution script automates the following stages:

- Data Download - Retrieves required datasets

- Data Pre-processing - Prepares data for training

- Model Training - Trains the Queen model on processed data

- Rendering - Generates final output using trained model

### Notes

- Ensure sufficient disk space in both data and output directories

- The complete process may take considerable time depending on data size and hardware

- Monitor GPU memory usage during execution

- Output files will be saved to ~/workspace/queen/output/