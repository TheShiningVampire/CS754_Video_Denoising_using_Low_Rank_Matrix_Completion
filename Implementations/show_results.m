addpath('./yuv4mpeg2mov');
addpath('./utils');

path = '../Results/Coastguard/Denoised_video_param_set_2.mp4';

% Show the third frame of video at path
% [video_movie, video_info] = yuv4mpeg2mov(path);               % Read the video file

% % Get .cdata from the video_movie object
% num_frames = video_info.frameCount;                     % Get the number of frames in the video

% scale_factor = 1;                                      % Scale factor for the video
% video = read_video(video_movie, num_frames, scale_factor);

% % Show third frame of video
% figure(1);
% imshow(video(:,:,:,10));

% Read mp4 file using video reader
video_reader = VideoReader(path);

video_frame = read(video_reader, 10);

% Show third frame of video
figure(1);
imshow(video_frame);

% Calculate PSNR between original and noisy video
% num_frames = 20;
% path2 = '../Results/Bus/Gaussia_dominated/noisy_video_param_set1.mp4';
% video_reader = VideoReader(path2);
% video_noisy = read(video_reader, [1, num_frames]);

% disp(PSNR(video, video_noisy, num_frames));
