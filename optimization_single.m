function [ best_combination, iter, best_psnr ] = optimization_single( combinations, n_iter, option, T, noiseT )
%OPTIMIZATION Summary of this function goes here
%   Detailed explanation goes here
% best_idx_psnr_k, best_idx_psnr_l
% psnr_k = zeros(length(k), n_iter);
% psnr_l = zeros(length(lambda), n_iter);

psnr_global = zeros( length( combinations ), n_iter );

for row =1: size(combinations,1)
    [~, psnr_value] = dif_aniso(noiseT, T, n_iter, combinations(row,1), combinations(row,2), option);
    psnr_global(row,:) = psnr_value;
end
% Get the best PSNR ant #iter
[best_psnr, idx_g] = max(psnr_global(:));
[comb, iter] = ind2sub(size(psnr_global), idx_g);
best_combination = combinations(comb,:);
end

