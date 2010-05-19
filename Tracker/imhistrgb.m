function [ f,w ] = imhistrgb( IM, nbins )
% Returns histogram for RGB image
%   Histogram is not done in full RGB space. Instead
% the RGB values are concatenated along a vector

nbins = 10;
[ca_r ha_r] = imhist(IM(:,:,1), nbins);
[ca_g ha_g] = imhist(IM(:,:,2), nbins);
[ca_b ha_b] = imhist(IM(:,:,3), nbins);

% Features
f = cat(1,ha_r,ha_g+255,ha_b+2*255);

ca = cat(1,ca_r,ca_g,ca_b);

% Weights
w = ca / sum(ca);

end

