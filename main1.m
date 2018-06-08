clear all;
clc;
close all;

image1 = '..\Data\P1\Material_P1\T1.png';
image2 = '..\Data\P1\Material_P1\T2.png';

% Set multichanel to false and NLM to true to compare both algorithms
multichanel = false;
NLM_opt = true;
if NLM_opt
    t = 5;
    f = 5;
    h = 10;
end

% Initialize parameters for optimization
n_iter = 200;
lambda = .00:.005:.02;
k = 0:1:15;
option = [1 2];

[K,L] = meshgrid(k,lambda);
c = cat( 2, K', L' );
combinations = reshape( c, [], 2 );
n_comb = length(combinations);

% Read images
T1 = imread(image1);
T2 = imread(image2);
% T = [T1 T2];

% Add gaussian noise to images (default M=0, V=0.01)
disp("Let's start with image noising...");
noiseT1 = addNoise(T1);
noiseT2 = addNoise(T2);

if ~multichanel
    % Search optimum parameters
    % Notation: idx_<comb>_<T>_<opt>
    disp("Let's start with parameter optimization for single chanel...");
    [ best_combination_1_1, best_num_it_1_1, best_psnr_1_1 ] = optimization_single( combinations, n_iter, option(1), T1, noiseT1 );
    [ best_combination_2_1, best_num_it_2_1, best_psnr_2_1 ] = optimization_single( combinations, n_iter, option(1), T2, noiseT2 );
    [ best_combination_1_2, best_num_it_1_2, best_psnr_1_2 ] = optimization_single( combinations, n_iter, option(2), T1, noiseT1 );
    [ best_combination_2_2, best_num_it_2_2, best_psnr_2_2 ] = optimization_single( combinations, n_iter, option(2), T2, noiseT2 );
    
    fprintf( "Best combination for T1 using 'option 1' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_1_1, best_num_it_1_1, best_psnr_1_1 );
    fprintf( "Best combination for T1 using 'option 2' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_1_2, best_num_it_1_2, best_psnr_1_2 );
    fprintf( "Best combination for T2 using 'option 1' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_2_1, best_num_it_2_1, best_psnr_2_1 );
    fprintf( "Best combination for T2 using 'option 2' is %d-%2.3f with %d iterations and PSNR %2.3f\n\n", best_combination_2_2, best_num_it_2_2, best_psnr_2_2 );
    
    disp("Choosing best parameter combination...");
    if best_psnr_1_1 > best_psnr_1_2
        combT1 = best_combination_1_1;
        opt_T1 = option(1);
        iter_T1 = best_num_it_1_1;
    else
        combT1 = best_combination_1_2;
        opt_T1 = option(2);
        iter_T1 = best_num_it_1_2;
    end
    fprintf("The best option for T1 is the number %d and combination %d-%2.3f\n", opt_T1, combT1);
    
    if best_psnr_2_1 > best_psnr_2_2
        combT2 = best_combination_2_1;
        opt_T2 = option(1);
        iter_T2 = best_num_it_2_1;
    else
        combT2 = best_combination_2_2;
        opt_T2 = option(2);
        iter_T2 = best_num_it_2_2;
    end
    fprintf("The best option for T2 is the number %d and combination %d-%2.3f\n", opt_T2, combT2);
    
    disp("DONE!");
    
    [difT1, psnrT1] = dif_aniso(noiseT1, T1, iter_T1, combT1(1), combT1(2), opt_T1);
    [difT2, psnrT2] = dif_aniso(noiseT2, T2, iter_T2, combT2(1), combT2(2), opt_T2);
    PSNR1 = max(psnrT1);
    PSNR2 = max(psnrT2);
    
    figure('Name','Filtering result','NumberTitle','off');
    s1 = subplot(231);
    imshow(image1), title(s1, 'Original T1')
    s2= subplot(232);
    imshow(uint8(noiseT1)), title(s2, 'Ruidosa T1')
    s3 = subplot(233);
    imshow(uint8(difT1)), title(s3, 'Restaurada T1')
    
    s4 = subplot(234);
    imshow(image2), title(s4, 'Original T2')
    s5 = subplot(235);
    imshow(uint8(noiseT2)), title(s5, 'Ruidosa T2')
    s6 = subplot(236);
    imshow(uint8(difT2)), title(s6, 'Restaurada T2')
    
    if NLM_opt
        disp("Let's start with Non-Local Means filter...");
        [ output_NLM ] = NLM( noiseT1, t, f, h );
        PSNR_NOISE = PSNR_V(double(T1), double(noiseT1));
        PSNR_NLM = PSNR_V(double(T1), double(output_NLM));
        
        figure('Name','Filtering result','NumberTitle','off');
        s1 = subplot(131);
        imshow(uint8(noiseT1)), title(s1,{'Gaussiano','PSNR=',num2str(PSNR_NOISE)})
        s2= subplot(132);
        imshow(uint8(difT1)), title(s2,{'Perona-Malik','PSNR=',num2str(PSNR1)})
        s3 = subplot(133);
        imshow(uint8(output_NLM)), title(s3,{'Non-Local Means','PSNR=',num2str(PSNR_NLM)})
        disp("DONE!");
    end
else
    % Search optimum parameters
    % Notation: idx_<comb>_<T>_<opt>
    disp("Let's start with parameter optimization for multichanel...");
    [ best_combination_1_1, best_num_it_1_1, best_psnr_1_1, best_combination_2_1, best_num_it_2_1, best_psnr_2_1 ] = optimization_multi( combinations, n_iter, option(1), T1, noiseT1, T2, noiseT2 );
    [ best_combination_1_2, best_num_it_1_2, best_psnr_1_2, best_combination_2_2, best_num_it_2_2, best_psnr_2_2 ] = optimization_multi( combinations, n_iter, option(2), T1, noiseT1, T2, noiseT2 );
    
    fprintf( "Best combination for T1 using 'option 1' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_1_1, best_num_it_1_1, best_psnr_1_1 );
    fprintf( "Best combination for T1 using 'option 2' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_1_2, best_num_it_1_2, best_psnr_1_2 );
    fprintf( "Best combination for T2 using 'option 1' is %d-%2.3f with %d iterations and PSNR %2.3f\n", best_combination_2_1, best_num_it_2_1, best_psnr_2_1 );
    fprintf( "Best combination for T2 using 'option 2' is %d-%2.3f with %d iterations and PSNR %2.3f\n\n", best_combination_2_2, best_num_it_2_2, best_psnr_2_2 );
    
    disp("Choosing best parameter combination...");
    if best_psnr_1_1 > best_psnr_1_2
        combT1 = best_combination_1_1;
        opt_T1 = option(1);
        iter_T1 = best_num_it_1_1;
    else
        combT1 = best_combination_1_2;
        opt_T1 = option(2);
        iter_T1 = best_num_it_1_2;
    end
    fprintf("The best option for T1 is the number %d and combination %d-%2.3f\n", opt_T1, combT1);
    
    if best_psnr_2_1 > best_psnr_2_2
        combT2 = best_combination_2_1;
        opt_T2 = option(1);
        iter_T2 = best_num_it_2_1;
    else
        combT2 = best_combination_2_2;
        opt_T2 = option(2);
        iter_T2 = best_num_it_2_2;
    end
    fprintf("The best option for T2 is the number %d and combination %d-%2.3f\n", opt_T2, combT2);
    
    disp("DONE!");
    
    [difT1, psnrT1] = dif_aniso(noiseT1, T1, iter_T1, combT1(1), combT1(2), opt_T1);
    [difT2, psnrT2] = dif_aniso(noiseT2, T2, iter_T2, combT2(1), combT2(2), opt_T2);
    
    figure('Name','Filtering result','NumberTitle','off');
    s1 = subplot(231);
    imshow(image1), title(s1, 'Original T1')
    s2= subplot(232);
    imshow(uint8(noiseT1)), title(s2, 'Ruidosa T1')
    s3 = subplot(233);
    imshow(uint8(difT1)), title(s3, 'Restaurada T1')
    
    s4 = subplot(234);
    imshow(image2), title(s4, 'Original T2')
    s5 = subplot(235);
    imshow(uint8(noiseT2)), title(s5, 'Ruidosa T2')
    s6 = subplot(236);
    imshow(uint8(difT2)), title(s6, 'Restaurada T2')
end