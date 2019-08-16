function out = NGEQfilter(in,targetGains)
% Filter audio using the Neurally Controlled Graphic Equalizer
% out = NGEQfilter(in,b,a,G0)
%
% in = input audio signal
% out = filtered audio signal
% targetGains: vector (10x1) consisting the user-set gains [-12dB 12dB]
%
%
% Written by Jussi Rämö, August 15, 2019

%% Calculate the optimized filter gains
filterGains = NGEQ(targetGains);

%% Design the individual EQ filters
[b,a,G0] = GEQfilters(filterGains);

%% Filter audio
% Init output
out = G0.*in;
% Filter with 10 EQ filters
for m = 1:10
	out = filter(b(m,:),a(m,:),out);
end

