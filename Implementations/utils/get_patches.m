function patches_arr = get_patches(block_video, patch_size)
    % get vectorized patches from a video
    % block_video: video to be splitted
    % patch_size: size of the patch
    % patches_arr: array of patches

    [height, width, C, num_frames] = size(block_video);
    
    patches_arr = zeros(patch_size*patch_size* C, height-patch_size+1, width-patch_size+1, num_frames);

    for k = 1:num_frames
        for i = 1:height-patch_size+1
            for j = 1:width-patch_size+1
                patches_arr(:, i, j, k) = reshape(block_video(i:i+patch_size-1, j:j+patch_size-1, :, k), patch_size*patch_size*C, 1);
            end
        end
    end
end
