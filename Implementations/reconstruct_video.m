function [denoised_video, denoised_video_counts] = reconstruct_video(Q_jk, P_jk_indices, denoised_video, denoised_video_counts, patch_size, num_patch_match, size_block, block_start, block_end)

    H = size_block(1);
    W = size_block(2)
    denoised_block = zeros(size_block);
    denoised_block_counts = zeros(size_block);
    for k = 1:floor(size(Q_jk, 2)/num_patch_match)
        % Things of interest at current frame
        Q_jk_k = Q_jk(:, (k-1)*num_patch_match+1:k*num_patch_match);
        P_jk_indices_k = P_jk_indices(:, (k-1)*num_patch_match+1:k*num_patch_match);

        red_channel = zeros(H,W);
        green_channel = zeros(H,W);
        blue_channel = zeros(H,W);

        red_channel_counts = zeros(H,W);
        green_channel_counts = zeros(H,W);
        blue_channel_counts = zeros(H,W);

        red_channel_cols = im2col(red_channel, [patch_size patch_size], 'sliding');
        green_channel_cols = im2col(green_channel, [patch_size patch_size], 'sliding');
        blue_channel_cols = im2col(blue_channel, [patch_size patch_size], 'sliding');

        red_channel_cols_counts = im2col(red_channel_counts, [patch_size patch_size], 'sliding');
        green_channel_cols_counts = im2col(green_channel_counts, [patch_size patch_size], 'sliding');
        blue_channel_cols_counts = im2col(blue_channel_counts, [patch_size patch_size], 'sliding');

        red_channel_cols(:, P_jk_indices_k(1,:)) = Q_jk_k(1:patch_size^2, :);
        green_channel_cols(:, P_jk_indices_k(1,:)) = Q_jk_k(patch_size^2+1:2*patch_size^2, :);
        blue_channel_cols(:, P_jk_indices_k(1,:)) = Q_jk_k(2*patch_size^2+1:3*patch_size^2, :);

        red_channel_cols_counts(:, P_jk_indices_k(1,:)) = ones(patch_size^2, num_patch_match);
        green_channel_cols_counts(:, P_jk_indices_k(1,:)) = ones(patch_size^2, num_patch_match);
        blue_channel_cols_counts(:, P_jk_indices_k(1,:)) = ones(patch_size^2, num_patch_match);

        red_channel = col2im(red_channel_cols, [patch_size patch_size], [H W], 'sliding');
        green_channel = col2im(green_channel_cols, [patch_size patch_size], [H W], 'sliding');
        blue_channel = col2im(blue_channel_cols, [patch_size patch_size], [H W], 'sliding');

        denoised_block(:,:,:,k) = cat(3, red_channel, green_channel, blue_channel);
        denoised_block_counts(:,:,:,k) = cat(3, red_channel_cols_counts, green_channel_cols_counts, blue_channel_cols_counts);
    end

    denoised_video(:,:,:,block_start:block_end) = denoised_video(:,:,:,block_start:block_end) + denoised_block;
    denoised_video_counts(:,:,:,block_start:block_end) = denoised_video_counts(:,:,:,block_start:block_end) + denoised_block_counts;
end





