clear;
close all;
clc;

% Add path for video reader function and the utils folder
addpath('./yuv4mpeg2mov');
addpath('./utils');

%% Read the data (video file)
[video_movie, video_info] = yuv4mpeg2mov('../Data/bus_cif.y4m');               % Read the video file

% Get .cdata from the video_movie object
num_frames = video_info.frameCount;                     % Get the number of frames in the video

video = read_video(video_movie, num_frames);            % Read the video as a matrix
                                                        % video ~ [height x width x channel x frame]

% Noise parameters to the video
sigma = 20;
kappa = 5;
s = 0.2;

% Converting video from unit8 to double
video = im2double(video);
sigma = sigma/255;
kappa = kappa/255;


video_noisy = add_video_noise(video, num_frames, sigma, kappa, s);

% % Show the video frame
% figure; imshow(video(:,:,:,1)); title('Original Video Frame 1');
% figure; imshow(video_noisy(:,:,:,1)); title('Noisy Video Frame 1');

% % Write the noisy video to a file using the same video parameters as the original video using VideoWriter
% write_video(video_noisy, '../Data/bus_cif_noisy', video_info);

K = 50;
num_blocks = num_frames/K;
patch_size = 8;

for i = 1:num_blocks
    block_start = (i-1)*K + 1;
    block_end = i*K;
    
    block_video = video_noisy(:,:,:,block_start:block_end);         % Get the block of video
                                                                    % block_video ~ [H x W x C x K]

    % Get patches from the video
    patches = get_patches(block_video, patch_size);       % patches ~ [patch_size^2*C x num_patches]

    % Get similar patches for each patch
    num_patches = size(patches,2);

    for i = 1:num_patches
        
                                                                
end











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               FUNCTIONS                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function video = read_video(video_movie, num_frames)
    % Read the video
    video = [];
    for i = 1:num_frames
        video = cat(4, video, video_movie(i).cdata);
    end
end

function video = read_grayscale_video(video_movie, num_frames)
    % Read the video
    video = [];
    for i = 1:num_frames
        video = cat(4, video, rgb2gray(video_movie(i).cdata));
    end
end

function noisy_video = add_video_noise(video, num_frames, sigma, kappa, s)
    noisy_video = video;
    for i = 1:num_frames
        video_frame = video(:,:,:,i);

        % Add Gaussian Noise to the video frame
        noisy_video_frame = video_frame + sigma * randn(size(video_frame));

        % Add Poisson Noise with zero mean and kappa*pixel value as variance
        poisson_noise = poissrnd(kappa * noisy_video_frame) - kappa * noisy_video_frame;
        noisy_video_frame = noisy_video_frame + poisson_noise;

        % Add impulsive noise with probability s
        impulsive_noise = rand(size(video_frame)) < s;

        % Pixel values at non zero impulsive_noise are +1 and -1 with probability 0.5
        impulsive_noise_value = 2 * ((rand(size(impulsive_noise)) < 0.5) - 0.5);
        impulsive_noise_value(impulsive_noise == 0) = 0;

        % Add impulsive noise to the video frame
        noisy_video_frame(impulsive_noise_value == 1) = 1;
        noisy_video_frame(impulsive_noise_value == -1) = 0;

        % Add the noisy video frame to the noisy video
        noisy_video(:,:,:,i) = noisy_video_frame;
    end
end

function write_video(video, path, video_info)
    % Convert the original video to unint8
    video = im2uint8(video);
    writerObj = VideoWriter(path);
    writerObj.FrameRate = video_info.fps;
    num_frames = video_info.frameCount;
    open(writerObj);
    for i = 1:num_frames
        writeVideo(writerObj, video(:,:,:,i));
    end
    close(writerObj);
end
