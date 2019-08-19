% Plots the magnitude response of the Neurally Controlled Graphic Equalizer
%
% Serves as an example how to utilize the function included in the NGEQ package
% plotNGEQ(targetGains)
%
% targetGains: vector (10x1) consisting the user-set gains [-12dB 12dB]
%
% Written by Jussi Rämö, August 15, 2019

%% User-set target gains - CHANGE THESE TO EXPERIMENT w/ NGEQ
targetGains = [12 -12 12 -12 12 -12 12 -12 12 -12]';	% Zig Zag gains
% targetGains = randi([-12 12],10,1); 					% Random gains


fs = 44100;					% Sample rate
fc = 16000./(2.^(9:-1:0)); 	% Ocatave center frequencies

%% Calculate the optimized filter gains
filterGains = NGEQ(targetGains);

%% Design the individual EQ filters
[b,a,G0] = GEQfilters(filterGains);

%% Filter an impulse
in = [1; zeros(fs-1,1)]; % Create an impulse
out = G0.*in;			 % Multiply by G0
% Filter with 10 EQ filters
for m = 1:10
	out = filter(b(m,:),a(m,:),out);
end

%% Calculate spectrum and plot
len = length(out);
spectr = abs(fft(out));
spectr = 20*log10(spectr(1:len/2));
dfreq = fs/len;
splen = length(spectr);
frq = linspace(0,dfreq*(splen-1),splen);

fig = figure;
semilogx(frq,spectr,'k','LineWidth',2);
hold on;
plot(fc,targetGains,'ko','MarkerSize',10)
plot(fc,filterGains,'kx','MarkerSize',10)
plot([20 fs/2],[12 12],'--k')
plot([20 fs/2],[-12 -12],'--k')
hold off;
xlim([20 fs/2]);
grid on;
set(gca,'XTick',[100 1000 10000]);
set(gca,'XTickLabel',{'100','1k','10k'},'Fontname','Times','Fontsize',18)
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
ylim([-25 25])
legend('NGEQ response','Target gains','Filter gains','location','northeastoutside')
fig.Position(3) = 800;