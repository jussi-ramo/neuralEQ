function filterGains = NGEQ(targetGains)
% NGEQ filter gain calculation
% filterGains = NGEQ(targetGains)
%
% targetGains: vector (10x1) consisting the user-set gains [-12dB 12dB]
% filterGains: optimized output gains in dB
%
% Written by Jussi Rämö, August 15, 2019.

%% Check input vector size. Should be 10 x 1
[row,col] = size(targetGains);
if row == 10 && col == 1
	targetGains = targetGains;
elseif row == 1 && col == 10;
	targetGains = targetGains';
else
	error('targetGains vector has the wrong size! Should be 10 x 1 column vector.')
end

%% Initialize outputs and variables
g = zeros(10,1);			% Scaled input gains [-1 1]
o = zeros(20,1);			% Output of the hidden layer
gopt = zeros(10,1);			% Scaled output gains [-1 1]
filterGains = zeros(10,1);	% Output gains in dB

%% Load neural net parameters needed in Eqs. (15)-(18)
load NGEQ_parameters.mat 

%% Filter gain calculation
g = 2.*(targetGains - xmin)./(xmax-xmin) - 1;	% Eq. (15)
o = tanh(W1*g + theta1);						% Eq. (16)
gopt = W2*o + theta2;							% Eq. (17)
filterGains = (tmax-tmin).*(gopt + 1)/2 + tmin;	% Eq. (18)
