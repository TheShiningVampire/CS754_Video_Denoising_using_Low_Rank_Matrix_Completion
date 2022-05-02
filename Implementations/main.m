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
sigma = 30;
kappa = 15;
s = 0.2;

% Converting video from unit8 to double
video = double(video);
sigma = sigma;
kappa = kappa;


video_noisy = add_video_noise(video, num_frames, sigma, kappa, s);

% % % Show the video frame
% figure; imshow(uint8(video(:,:,:,1))); title('Original Video Frame 1');
% figure; imshow(uint8(video_noisy(:,:,:,1))); title('Noisy Video Frame 1');
% 
% % Write the noisy video to a file using the same video parameters as the original video using VideoWriter
% write_video(video_noisy, '../Data/bus_cif_noisy', video_info);

K = 5;
num_patch_match = 5;
% num_blocks = num_frames/K;
num_frames = 10;
patch_size = 8;
threshold_omega = 50;                               % Threshold used for forming omega

H = size(video,1);                                  % Height of the video
W = size(video,2);                                  % Width of the video

denoised_video = zeros(H,W,3,num_frames);
denoised_video_counts = zeros(H,W,3,num_frames);

for k = 1:num_frames
    disp(k);
    block_start = max(1, k-floor(K/2));
    block_end = block_start + K - 1;

    if block_end > num_frames
        block_end = num_frames;
        block_start = block_end - K + 1;
    end
    
    block_video = video_noisy(:,:,:,block_start:block_end);         % Get the block of video
                                                                    % block_video ~ [H x W x C x K]

    % Get patches from the video
    for i = 1:H - patch_size + 1
        for j = 1:W - patch_size + 1
            patch = block_video(i:i+patch_size-1, j:j+patch_size-1, :, k);
            [P_jk, P_jk_indices, row_col_indices] = patch_matching_and_grouping(patch, patch_size, num_patch_match, block_video);

            % Generate the omega matrix 
            [omega , sigma_hat] = Omega_gen(P_jk, threshold_omega);

            % Denoise the patches and get the Q matrix
            Q_jk = fix_point_iter(P_jk, omega, size(P_jk,1), size(P_jk,2), sigma_hat);

            % Reconstruct the video
            [denoised_video, denoised_video_counts] = reconstruct_video(Q_jk, row_col_indices, denoised_video, denoised_video_counts, patch_size, num_patch_match, size(block_video), block_start, block_end);
        end
    end
                                                                
end
denoised_video = denoised_video./denoised_video_counts;

write_video(denoised_video, '../Data/bus_cif_denoised', video_info);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%               FUNCTIONS                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        poisson_noise = poissrnd(kappa * abs(video_frame)) - kappa * video_frame;
        noisy_video_frame = noisy_video_frame + poisson_noise;

        % Add impulsive noise with probability s
        impulsive_noise = rand(size(video_frame)) < s;

        % Pixel values at non zero impulsive_noise are +1 and -1 with probability 0.5
        impulsive_noise_value = 2 * ((rand(size(impulsive_noise)) < 0.5) - 0.5);
        impulsive_noise_value(impulsive_noise == 0) = 0;

        % Add impulsive noise to the video frame
        noisy_video_frame(impulsive_noise_value == 1) = 255;
        noisy_video_frame(impulsive_noise_value == -1) = 0;

        % Add the noisy video frame to the noisy video
        noisy_video(:,:,:,i) = noisy_video_frame;
    end
end

function write_video(video, path, video_info)
    % Convert the original video to unint8
    video = uint8(video);
    writerObj = VideoWriter(path);
    writerObj.FrameRate = video_info.fps;
    num_frames = video_info.frameCount;
    open(writerObj);
    for i = 1:num_frames
        writeVideo(writerObj, video(:,:,:,i));
    end
    close(writerObj);
end
