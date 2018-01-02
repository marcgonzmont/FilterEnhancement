clear all, close all, clc;

image1 = '..\Data\P1\Material_P1\T1.png';
image2 = '..\Data\P1\Material_P1\T2.png';

n_iter = 10;
k = [10 20 30 40 50 60];
lambda = [1/4 1/5 1/6 1/7 1/8 1/9 1/10];
option = [1 2];
psnr_k = [];
psnr_l = [];
T1 = imread(image1);
T2 = imread(image2);

for i = k
    [~, psnr_value] = dif_aniso(T1, n_iter, i, lambda(1), option(1));
    psnr_k = [psnr_k psnr_value];
end

for ii = lambda
    [~, psnr_value] = dif_aniso(T1, n_iter, k(1), ii, option(1));
    psnr_l = [psnr_l psnr_value];
end

figure(2);
% subplot(121);
bar(k, psnr_k)
title('PSNR vs. K')
% subplot(121);
figure(3);
bar(lambda, psnr_l)
title('PSNR vs. LAMBDA')
