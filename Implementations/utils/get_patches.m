function patches = get_patches(block_video, patch_size)
    % get vectorized patches from a video
    % block_video: video to be splitted
    % patch_size: size of the patch
    % patches: patches from the video
    
    patches = [];
    [height, width, C, K] = size(block_video);
    
    for k = 1:K
        for i = 1:height-patch_size+1
            for j = 1:width-patch_size+1
                patch = block_video(i:i+patch_size-1, j:j+patch_size-1, :, k);
                patches = cat(1, patches, patch(:));
            end
        end
    end
end
