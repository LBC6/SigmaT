# SigmaT
A quantitative model for converting lithospheric conductivity to rheological parameters based on magnetotelluric data

## Overview

This repository provides the MATLAB implementation of the SigmaT model, which quantitatively converts lithospheric electrical conductivity profiles derived from magnetotelluric (MT) data into critical rheological parameters, including geothermal temperature, melt fraction, and effective lithospheric viscosity. The code supports 3D slice visualization of calculation results for geophysical interpretation and geodynamic analysis of lithospheric structure.

## File Description

### Main Execution Script

- `plot3D_Slice_Temp_V.m`: The main entry script of the SigmaT workflow. It loads input MT conductivity data, invokes all core calculation functions, generates 3D slice plots of temperature and viscosity, and exports final result files.

### Core Calculation Functions

- `BULK.m`
- `Cal_Temp_V_Si14.m`
- `Fmelt.m`
- `MELT_CarSi14.m`
- `Tempmelt.m`
- `Viscosity_Xia13.m`
- `Solid_CPX.m`
- `Solid_GRT.m`
- `Solid_OL.m`
- `Solid_OPX.m`

### Example Input Data

- `egdataHorizontal-50km.txt`: Sample horizontal-slice MT conductivity dataset at 50 km depth, provided as the default test input for the model.

### Generated Output Files (produced after script execution)

- `egdataHorizontal-50km.txt_T.txt`: Output 2D temperature distribution data.
- `egdataHorizontal-50km.txt_V.txt`: Output 2D effective viscosity distribution data.
- `egdataHorizontal-50km.txt_M.txt`: Output 2D melt fraction distribution data.

## Requirements

- MATLAB R2024a or compatible version
- No additional third-party toolboxes are required for core calculation and plotting.

## Quick Start & Test Instructions

1. Download or clone all files in this repository to your local directory.
2. Launch MATLAB and set the current working folder to the directory containing all source files.
3. Run the main script by entering the following command in the MATLAB Command Window:
```
plot3D_Slice_Temp_V
```
4. The script will automatically load the sample input file `egdataHorizontal-50km.txt`, complete all calculation workflows, display 3D slice plots of temperature and viscosity, and generate the three output `.txt` files in the current folder.

## Citation

When using this code in academic work, please cite the associated paper:

> 
> Baochun Li, et al. SigmaT: A quantitative model for converting lithospheric conductivity to rheological parameters based on magnetotelluric data. *Computers & Geosciences*.
