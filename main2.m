clear all; clc; close all;

% Load images
image1 = '..\Data\P1\Material_P1\T1.png';
image2 = '..\Data\P1\Material_P1\T2.png';

% Configuration for Non-Local Means
t = 5;
k = 5;
h = 10;

% Read images
T1 = imread(image1);
T2 = imread(image2);
% T = [T1 T2];

% Add gaussian noise to images (default M=0, V=0.01)
disp("Let's start with image noising...");
noiseT1 = addNoise(T1);
noiseT2 = addNoise(T2);

% noiseT1 = double(noiseT1);
disp("Let's start with Non-Local Means filter...");
[ output_NLM ] = NLM( noiseT1, t, k, h );
PSNR_NOISE = PSNR_V(double(T1), double(noiseT1));
PSNR_NLM = PSNR_V(double(T1), double(output_NLM));

figure('Name','Filtering result','NumberTitle','off');
s1 = subplot(131);
imshow(image1), title(s1, 'Original T1')
s2= subplot(132);
imshow(uint8(noiseT1)), title(s2, 'Ruidosa T1')
s3 = subplot(133);
imshow(uint8(output_NLM)), title(s3, 'Restaurada T1 (NLM)')
