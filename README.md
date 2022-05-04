# Video Denoising using Low Rank Matrix Completion

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

This project was done as part of the course CS 754: Advanced Image Processing at Indian Institute of Technology, Bombay. In this project, we have implemented a video denoising algorithm using Low Rank Matrix Completion. The algorithm is based on the paper [Robust video denoising using low rank matrix completion](https://ieeexplore.ieee.org/document/5539849).

The results obtained from this project are shown in the following figure.

## Getting Started <a name = "getting_started"></a>

All codes written as part of this project are tested on Matlab R2020b. To run these codes a Matlab compiler is required. Apart from basic Matlab setup, no extra packages are required.

For reading the videos written in '.y4m' format, 'yuv4mpeg2mov' package has been used. This package is included in the Implementations folder.

## Usage <a name = "usage"></a>

To reproduce the results, run the code in 'Implementaions/main.m'. The code will use the "Bus" dataset included in the Data folder by default. To denoise any other video, change the path to the video in the 'main.m' file. The results obtained will be stored in the 'Results' folder.
