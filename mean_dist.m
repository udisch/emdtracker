function [val] =mean_dist(A,B)

% Histograms
nbins = 10;
[ca_r ha_r] = imhist(A(:,:,1), nbins);
[ca_g ha_g] = imhist(A(:,:,2), nbins);
[ca_b ha_b] = imhist(A(:,:,3), nbins);
[cb_r hb_r] = imhist(B(:,:,1), nbins);
[cb_g hb_g] = imhist(B(:,:,2), nbins);
[cb_b hb_b] = imhist(B(:,:,3), nbins);

% Features
f1 = cat(1,ha_r,ha_g+255,ha_b+2*255);
f2 = cat(1,hb_r,hb_g+255,hb_b+2*255);

ca = cat(1,ca_r,ca_g,ca_b);
cb = cat(1,cb_r,cb_g,cb_b);

ca_norm = ca/norm(ca);
cb_norm = cb/norm(cb);

val = 1-((ca.^0.5)'*(cb.^0.5)/(norm(ca)*norm(cb)));