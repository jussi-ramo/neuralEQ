% Neural network training script for Neurally Controlled Graphic Equalizer
%
% Published in IEEE/ACM Transactions on Audio, Speech and Language Perocessing,
% Vol. 27, No 12, pp. 2140-2149, December 2019.
%
% Utilizes Matlab's fitnet function (Deep Learning Toolbox)
%
% Outputs net object, which can be used as follows
% optimizedGains = net(targetGains);
%
% Written by Jussi Rämö, October 15, 2019

clear all;
load trainingData44kHz.mat; % Load training data: 1000 input-output pairs

dataPoints = 600; % Number of training data sample pairs
disp(['Number of training data samples: ' num2str(dataPoints)]);
x = Gin(:,1:dataPoints);   % Input gains
t = Gout(:,1:dataPoints);  % Output gains

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
% trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
trainFcn = 'trainbr';

% Create a Fitting Network
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'divideblock';  % Divide data in blocks - includes first part in the training (special cases)
net.divideMode = 'sample';  % Divide up every sample
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.testRatio = 30/100;

% Stopping conditions
net.trainParam.goal = 1e-5;
net.trainParam.epochs = 10000;

% Train the Network
[net,tr] = train(net,x,t);

% Test the network and calculate performance
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
disp(['Performance (mse) = ' num2str(performance)]);
