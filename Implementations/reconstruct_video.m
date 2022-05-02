function [denoised_video, denoised_video_counts] = reconstruct_video(Q_jk, row_col_indices, denoised_video, denoised_video_counts, patch_size, num_patch_match, size_block, block_start, block_end)

    H = size_block(1);
    W = size_block(2);
    denoised_block = zeros(size_block);
    denoised_block_counts = zeros(size_block);
    for k = 1:floor(size(Q_jk, 2)/num_patch_match)
        patches_considered = row_col_indices(:,:,k);
        Q_k = Q_jk(:,(k-1)*num_patch_match+1:k*num_patch_match);
        for j = 1:num_patch_match
            denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 1, k) = denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 1, k) + reshape(Q_k(1:patch_size^2, j), patch_size, patch_size);

            denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 1, k) = denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 1, k) + 1;

            denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 2, k) = denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 2, k) + reshape(Q_k(patch_size^2+1:2*patch_size^2, j), patch_size, patch_size);

            denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 2, k) = denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 2, k) + 1;

            denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 3, k) = denoised_block(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 3, k) + reshape(Q_k(2*patch_size^2+1:3*patch_size^2, j), patch_size, patch_size);

            denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 3, k) = denoised_block_counts(patches_considered(j,1):patches_considered(j,1)+patch_size-1, patches_considered(j,2):patches_considered(j,2)+patch_size-1, 3, k) + 1;
        end
    end

    denoised_video(:,:,:,block_start:block_end) = denoised_video(:,:,:,block_start:block_end) + denoised_block;
    denoised_video_counts(:,:,:,block_start:block_end) = denoised_video_counts(:,:,:,block_start:block_end) + denoised_block_counts;
end





