function [b0, num, den] = pareq2(G, GB, wc, B)
% [num, den] = pareq2(G, GB, wc, B)
% Second-order parametric equalizing filter design 
% with adjustable bandwidth gain 
%
% [b0, num, den] = pareq(G, GB, wc, B)
%
% Parameters
% G = peak gain (linear)
% GB = bandwidth gain (linear)
% wc = center frequency (rads/sample)
% B = bandwidth (rads/sample)
%
% Output
% b0 = Gain factor (linear)
% num = [1, b1, b2] = numerator coefficients
% den = [1, a1, a2] = denominator coefficients
%
% Written by Vesa Valimaki, August 24, 2016
% Modified by Vesa Valimaki and Jussi Ramo, August 19, 2019
% Equations modified to have the same form as presented in the paper, see Eq. (3).
%
% Ref. S. Orfanidis, Introduction to Signal Processing, p. 594
% We have set the dc gain to G0 = 1.

if G==1
    beta = tan(B/2);  % To avoid division by zero, when G=1. 	% Eq. (6)
else
    beta = sqrt(abs(GB^2 - 1)/abs(G^2 - GB^2)) * tan(B/2); 		% Eq. (5)
end

b0 = (1 + G*beta)/(1 + beta);									% Eq. (4)
num = [1, -2*cos(wc)/(1 + G*beta), (1 - G*beta)/(1 + G*beta)];	% Eq. (7)
den = [1, -2*cos(wc)/(1 + beta), (1 - beta)/(1 + beta)];		% Eq. (8)
