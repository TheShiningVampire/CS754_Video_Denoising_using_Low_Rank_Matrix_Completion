function [Q] = fix_point_iter(P, Omega, N, m, sigma_hat )
%     P: patch matrix of size (N, m)
%     (N, m): N=n^2*c for patch of size n x n. Total similar patches = m
%      where c is no. of channels
%     Omega: index set of reliable elements
%     Q: output denoised patch matrix

    p = numel(Omega)/ numel(P);
    mu = (sqrt(N) + sqrt(m))* sqrt(p)* sigma_hat;
    tau = 1.5;            % choose 1< tau < 3
    epsilon = 10.^(-4);   % choose epsilon < 10^-5
    max_iter = 30;         % max iterations for stopping criteria
    curr_iter = 0;
    curr_Q = zeros(N,m);
    Proj_omega ???
    
    while norm(curr_Q-prev_Q, 'fro')<epsilon && curr_iter<max_iter
        R = curr_Q - tau* Proj_omega(curr_Q - P);
        prev_Q = curr_Q;
       
        % SVT on R
        [U, S, V] = svd(R);
        S_tau = diag(S)-(tau*mu);
        S_tau(S_tau<0) = 0;
        S_tau = diag(S_tau);
        curr_Q = U*S_tau*V';
        curr_iter = curr_iter+1;
    end
end