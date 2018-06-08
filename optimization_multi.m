function [ best_combination1, iter1, best_psnr_1, best_combination2, iter2, best_psnr_2 ] = optimization_multi( combinations, n_iter, option, T1, noiseT1, T2, noiseT2 )
%OPTIMIZATION Summary of this function goes here
%   Detailed explanation goes here
% best_idx_psnr_k, best_idx_psnr_l
% psnr_k = zeros(length(k), n_iter);
% psnr_l = zeros(length(lambda), n_iter);

psnr1_global = zeros( length( combinations ), n_iter );
psnr2_global = zeros( length( combinations ), n_iter );

for row =1: size(combinations,1)
    [~, psnr1_value, ~, psnr2_value] = dif_aniso_multichanel(noiseT1, noiseT2, n_iter, combinations(row,1), combinations(row,2), option, T1, T2);
    psnr1_global(row,:) = psnr1_value;
    psnr2_global(row,:) = psnr2_value;
end
% Get the best PSNR and #iter
[best_psnr_1, idx_g_1] = max(psnr1_global(:));
[best_psnr_2, idx_g_2] = max(psnr2_global(:));
[comb1, iter1] = ind2sub(size(psnr1_global), idx_g_1);
[comb2, iter2] = ind2sub(size(psnr2_global), idx_g_2);
best_combination1 = combinations(comb1,:);
best_combination2 = combinations(comb2,:);
    
end
