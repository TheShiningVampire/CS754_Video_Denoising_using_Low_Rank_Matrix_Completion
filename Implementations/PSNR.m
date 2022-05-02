function out = PSNR(denoised_video, ref_video, n_frames)
        peak_psnrs = psnr(denoised_video, ref_video);
        out = mean(peak_psnrs);
 
end