function video = read_video(video_movie, num_frames, scale_factor)
    % Read the video
    video = [];
    for i = 1:num_frames
        video_frame = video_movie(i).cdata;
        
        % Resize the video
        video_frame = imresize(video_frame, scale_factor);

        video = cat(4, video, video_frame);
    end
end
