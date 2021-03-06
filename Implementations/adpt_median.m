function [out_img, med_omega] = adpt_median(image, max_winsize, if_omega_only)
%   set if_omega_only to true for saving resources.
    [rows,cols,c] = size(image);
    out_img = image;
    med_omega = ones(size(image));
    
    for x = 1:c
        for i = 1:rows
            for j = 1:cols
                win_s = min([max_winsize,i-1,j-1,rows-i,cols-j]);
                %first level
                
                for W = 0:win_s
                    S = image(i-W:i+W,j-W:j+W,x);
                    xmed = median(S,'all');
                    xmin = min(S,[],'all');
                    xmax = max(S,[],'all');
                    
                    if if_omega_only
                        break
                    end
                    
                    Tminus = xmed - xmin;
                    Tplus = xmax - xmed;
                    if (Tminus > 0 && Tplus > 0)
                        break
                    end
                end
                %second level
                Uminus = image(i,j,x)-xmin;
                Uplus = xmax-image(i,j,x);
                if ~(Uminus > 0 && Uplus > 0)
                    out_img(i,j,x) = xmed;
                    med_omega(i,j,x) = 0;
                end
            end
        end
    end
    
end