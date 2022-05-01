function [output] = Omega_gen(P)
%   output is a logical matrix giving reliable pixel indices i.e. Omega

    [rows, cols] = size(P)
    output = zeros(rows, cols);
    
    for i=1:rows
        row_vec = P(i,:);
        row_vec = abs(row_vec - mean(row_vec));
        var = var(row_vec);
        indices = (row_vec < 2*sqrt(var));
        output(i,:) = indices;
    end

end