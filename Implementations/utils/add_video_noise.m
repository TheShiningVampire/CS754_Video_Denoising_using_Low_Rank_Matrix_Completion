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
