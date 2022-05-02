function write_video(video, path, video_info, num_frames)
    % Convert the original video to unint8
    video = uint8(video);
    writerObj = VideoWriter(path);
    writerObj.FrameRate = video_info.fps;

    open(writerObj);
    for i = 1:num_frames
        writeVideo(writerObj, video(:,:,:,i));
    end
    close(writerObj);
end