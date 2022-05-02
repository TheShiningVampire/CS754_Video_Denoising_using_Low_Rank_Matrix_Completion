function [patch_matches, patch_indices, row_col_indices] =  patch_matching_and_grouping(patch, patch_size, num_patch_match, block_video)
    % patch_matching_and_grouping
    %
    % Inputs:
    %   - patch: the patch to be matched
    %   - patch_size: the size of the patch
    %   - num_patch_match: the number of patch to be matched in each frame
    %   - block_video: the video to be matched

    % Outputs:
    %   - patch_matches: the matched patches 

    % Convert patch to a column vector
    patch = patch(:);

    num_frames = size(block_video, 4);
    patch_matches = [];
    patch_indices = [];
    row_col_indices = [];
    for k = 1:num_frames
        frame = block_video(:, :, :, k);

        % Make patches from the video rgb image by stacking the colours in the columns
        frame_patches_r = im2col(frame(:,:,1), [patch_size patch_size], 'sliding');
        frame_patches_g = im2col(frame(:,:,2), [patch_size patch_size], 'sliding');
        frame_patches_b = im2col(frame(:,:,3), [patch_size patch_size], 'sliding');

        % Make the colours into a single column vector
        frame_patches = cat(1, frame_patches_r, frame_patches_g, frame_patches_b);

        % Compute the l1 distance between the patch and the frame patches
        dist = sum(abs(frame_patches - repmat(patch, 1, size(frame_patches, 2))), 1);

        % Sort the distance and select the top num_patch_match
        [~, idx] = sort(dist);
        P_jk_frame = frame_patches(:, idx(1:num_patch_match));
        P_jk_indices = idx(1:num_patch_match);

        % Append the patch matches
        patch_matches = [patch_matches, P_jk_frame];
        patch_indices = [patch_indices, P_jk_indices];

        % Find the row and column indices of the patch matches
        [row_indices, col_indices] = ind2sub(size(frame), P_jk_indices);

        % Form a matrix with row and column indices as tuples
        row_col_indices_t = [row_indices; col_indices]';

        % Append the row and column indices to the list of indices
        row_col_indices = cat(3, row_col_indices, row_col_indices_t);
    end


