# Video Denoising using Low Rank Matrix Completion

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](#contributing)

## About <a name = "about"></a>

This project was done as part of the course CS 754: Advanced Image Processing at Indian Institute of Technology, Bombay. In this project, we have implemented a video denoising algorithm using Low Rank Matrix Completion. The algorithm is based on the paper [Robust video denoising using low rank matrix completion](https://ieeexplore.ieee.org/document/5539849).

The results obtained from this project are shown in the following figure. 
Noisy video | Median filtered video | Denoised video
--- | --- | ---
![noisy-video-param-set1_4ZEpXnwz](https://user-images.githubusercontent.com/55876739/166801426-96467221-20e6-4db5-968e-3534fbae8445.gif) | ![median-filtered-video-param-set-1_7pjAAWy1](https://user-images.githubusercontent.com/55876739/166802087-8708b47c-ed69-43e1-8e07-788e10178263.gif) | ![denoised-video-param-set-1_Jj9Hr5fc](https://user-images.githubusercontent.com/55876739/166801442-d9b79c0e-6516-4f72-8490-7546679d691b.gif) |
![noisy-video-param-set1_r75ih9jh](https://user-images.githubusercontent.com/55876739/166802223-40bcafc3-24d4-4748-b296-a411e5b2c39b.gif) | ![median-filtered-video-param-set-1_0AkW8BA8](https://user-images.githubusercontent.com/55876739/166802254-624ce278-f371-4d86-b991-1e0f6e8cf3c8.gif) | ![denoised-video-param-set-1_ZDGQFTRi](https://user-images.githubusercontent.com/55876739/166802289-f1d9423a-7013-468d-8396-860aaa716285.gif)





## Getting Started <a name = "getting_started"></a>

All codes written as part of this project are tested on Matlab R2020b. To run these codes a Matlab compiler is required. Apart from basic Matlab setup, no extra packages are required.

For reading the videos written in '.y4m' format, 'yuv4mpeg2mov' package has been used. This package is included in the Implementations folder.

## Usage <a name = "usage"></a>

To reproduce the results, run the code in 'Implementaions/main.m'. The code will use the "Bus" dataset included in the Data folder by default. To denoise any other video, change the path to the video in the 'main.m' file. The results obtained will be stored in the 'Results' folder.

## Contributing <a name = "contributing"></a>
Team members:
[Vinit Awale](https://github.com/TheShiningVampire)
[Piyush Bharambe](https://github.com/pi-sky)
