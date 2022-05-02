function out = PSNR(denoised_video, ref_video, num_frames)

        denoised_video = uint8(denoised_video(:,:,:,1:num_frames));
        ref_video = uint8(ref_video(:,:,:,1:num_frames));

        peak_psnrs = psnr(denoised_video, ref_video, "DataFormat","SSCB");
        out = mean(peak_psnrs);
end