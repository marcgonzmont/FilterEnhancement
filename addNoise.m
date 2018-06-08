function [ noise_image ] = addNoise( image )
%ADDNOISE Summary of this function goes here
%   Detailed explanation goes here
    noise_image = imnoise(image, 'gaussian');

end

