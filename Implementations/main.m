clear;
close all;
clc;

% Add path for video reader function and the utils folder and algos folder
addpath('./yuv4mpeg2mov');
addpath('./utils');
addpath('./Low_Rank_Matrix_Completion');

tic;
%% Read the data (video file)
[video_movie, video_info] = yuv4mpeg2mov('../Data/bus_cif.y4m');               % Read the video file

% Get .cdata from the video_movie object
num_frames = video_info.frameCount;                     % Get the number of frames in the video

scale_factor = 0.25;                                      % Scale factor for the video
video = read_video(video_movie, num_frames, scale_factor);            % Read the video as a matrix
                                                        % video ~ [height x width x channel x frame]

% Noise parameters to the video
% sigma = 10;
% kappa = 15;
% s = 0.2;
% noise_params = [[50 15 0.2], [10 25 0.2]];
noise_params = [[50 15 0.2], [10 25 0.2]];
data = 'Bus';
% data = 'Coastguard';

for i=1:2
    [sigma, kappa, s] = noise_params(i);
    % Print method start message
    fprintf('Starting method for sigma = %d, kappa = %d, s = %d\n', sigma, kappa, s);
    
    K = 2;                                         % Number of neighbourhood frames to consider
    num_patch_match = 5;                            % Number of patches to match in a frame
    num_frames = 2;
    patch_size = 8;
    threshold_omega = 50;                           % Threshold used for forming omega
    
    % Converting video from unit8 to double
    video = double(video);

    video_noisy = add_video_noise(video, num_frames, sigma, kappa, s);

    % % % Show the video frame
    % figure; imshow(uint8(video(:,:,:,1))); title('Original Video Frame 1');
    % figure; imshow(uint8(video_noisy(:,:,:,1))); title('Noisy Video Frame 1');

    
    
    % % Write the noisy video to a file using the same video parameters as the original video using VideoWriter
    write_video(video_noisy, strcat('../Results/',data, '/noisy_video_param_set', num2str(i)), video_info, num_frames); 
    
    H = size(video,1);                                  % Height of the video
    W = size(video,2);                                  % Width of the video
    C = size(video,3);                                  % No. of channels

    search_pixel_patch = 20;                            % Search pixel patch size

    stride = 4;                                         % Stride while moving the pixels while denoising

    % Median Filter parameters
    max_window_size = 6;

    denoised_video = zeros(H,W,C,num_frames);
    denoised_video_counts = zeros(H,W,C,num_frames);

    % Median Filtering
    median_filtered_video = zeros(H,W,C,num_frames);
    med_filt_omega = zeros(H,W,C,num_frames);
    for k = 1:num_frames
        disp(k);
        [median_filtered_video(:,:,:,k), med_filt_omega(:,:,:,k)] = adpt_median(video_noisy(:,:,:,k), max_window_size, false);
    end

    write_video(median_filtered_video, strcat('../Results/', data, '/Median_Filtered_video_param_set_', string(i)), video_info, num_frames);

    for k = 1:num_frames
        disp(k);
        block_start = max(1, k-floor(K/2));
        block_end = block_start + K - 1;

        if block_end > num_frames
            block_end = num_frames;
            block_start = block_end - K + 1;
        end
        
        block_video = median_filtered_video(:,:,:,block_start:block_end);         % Get the block of video
                                                                        % block_video ~ [H x W x C x K]

        block_omega = med_filt_omega(:,:,:,block_start:block_end);
                                                                        % block_omega ~ [H x W x C x K]

        % Get patches from the video
        for i = 1:stride:H - patch_size + 1
            disp(i);
            height_start = max(1, i-floor(search_pixel_patch/2));
            height_end = height_start + search_pixel_patch - 1;

            if height_end > H 
                height_end = H;
                height_start = height_end - search_pixel_patch + 1;
            end
                
            for j = 1:stride:W - patch_size + 1

                width_start = max(1, j-floor(search_pixel_patch/2));
                width_end = width_start + search_pixel_patch - 1;

                if width_end > W 
                    width_end = W;
                    width_start = width_end - search_pixel_patch + 1;
                end

                block_video_ij = block_video(height_start:height_end, width_start:width_end, :, :);
                block_omega_ij = block_omega(height_start:height_end, width_start:width_end, :, :);

                patch = block_video(i:i+patch_size-1, j:j+patch_size-1, :, k - block_start + 1);

                [P_jk, row_col_indices, omega_median] = patch_matching_and_grouping(patch, patch_size, num_patch_match, block_video_ij, block_omega_ij);

                % Generate the omega matrix 
                [omega , sigma_hat] = omega_gen(P_jk, threshold_omega, omega_median);

                % Denoise the patches and get the Q matrix
                Q_jk = fix_point_iter(P_jk, omega, size(P_jk,1), size(P_jk,2), sigma_hat);

                % Reconstruct the video
                [denoised_video, denoised_video_counts] = reconstruct_video(Q_jk, row_col_indices, denoised_video, denoised_video_counts, patch_size, num_patch_match, block_start, block_end, height_start, height_end, width_start, width_end, size(block_video_ij));
            end
        end

        toc;
                                                                    
    end
    denoised_video = denoised_video./denoised_video_counts;      % Divide the denoised video by the
                                                                % denoised video counts to get the 
                                                                % denoised video

    write_video(denoised_video, strcat('../Results/', data, '/Denoised_video_param_set_', string(i)), video_info, num_frames);
    % Writing the PSNR values to a txt file
    fileID = fopen(strcat('../Results/', data, '/PSNR_param_set_', string(i), '.txt'),'w');
    fprintf(fileID,'Median filtered video: %f\n',PSNR(video, median_filtered_video, num_frames));
    fprintf(fileID,'Denoised video: %f\n',PSNR(video, denoised_video, num_frames));
end




