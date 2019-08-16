function [b,a,G0] = GEQfilters(filterGains)
% Graphic EQ filter design for the Neurally Controlled Graphic Equalizer
% [b,a] = GEQfilters(filterGains)
%
% filterGains: Optimized EQ filter gains from NGEQ.m
%
% Written by Jussi Rämö, August 15, 2019

%% Octave center frequencies and bandwidths
fs  = 44100;  				% Sample rate
fc = 16000./(2.^(9:-1:0)); 	% Exact log center frequencies for filters
wc = 2*pi*fc/fs;  			% Command gain frequencies in radians
c = 0.3; 					% Gain factor at bandwidth (parameter c)
B = zeros(1,10); 			% EQ filter bandwidths
for m = 1:10;
    B(m) = 1.5*wc(m); 		% Eq (10)
end
B(8) = 0.93*B(8); B(9) = 0.78*B(9); B(10) = 0.5067*B(10); % Additional adjustmenst due to asymmetry

g = filterGains;			% Optimized filter gains in dB
G = 10.^(g/20);   			% Convert gains to linear gain factors
gB = c*g;      				% Gain at bandwidth edges  Eq. (2)
GB = 10.^(gB/20); 			% Convert to linear gain factor

b = zeros(10,3);  			% 3 numerator coefficients for each 10 filters
a = zeros(10,3);  			% 3 denominator coefficients for each 10 filters

% Filter design using NGEQ optimized gains with pareq.m
for m = 1:10,
    [num,den] = pareq(G(m), GB(m), wc(m), B(m)); % Design filters
    b(m,:) = num;
    a(m,:) = den;
end

% Scale numerator coefficients b and build G0 
for m = 1:10
	G0(m) = b(m,1);
	b(m,:) = 1/G0(m).*b(m,:);
end
G0 = prod(G0);				% Eq. (9)