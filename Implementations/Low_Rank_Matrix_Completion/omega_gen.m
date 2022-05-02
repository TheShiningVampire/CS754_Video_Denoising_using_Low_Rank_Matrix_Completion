function [output, sigma_hat] = omega_gen(P, threshold, omega_median)
%   output is a logical matrix giving reliable pixel indices i.e. Omega

    [rows, cols] = size(P);
    output = zeros(rows, cols);
    total_variance = 0;

    for i=1:rows
        row_vec = P(i,:);
        row_vec = abs(row_vec - mean(row_vec));
        variance = var(row_vec);
        indices = (row_vec < threshold);
        output(i,:) = indices;
        output(i,:) = output(i,:).*omega_median(i,:);



        total_variance = total_variance + variance;
    end

    sigma_hat = sqrt(total_variance / (rows * cols));
end
