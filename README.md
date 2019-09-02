# Neurally Controlled Graphic Equalizer
This repository has the Matlab scripts needed to run the Neurally Controlled Graphic Equalizer, introduced in IEEE/ACM Transaction on Audio, Speech and Language Processing by Jussi Rämö and Vesa Välimäki.

## Overview of the Paper
This work describes a neural network based method to simplify the design of a graphic equalizer without sacrificing the accuracy of approximation. The key idea is to train a neural network to predict the mapping from target gains to the optimized band filter gains at specified (octave) center frequencies. 

The prediction is implemented with a feedforward neural network having a hidden layer with 20 neurons in the case of the ten-octave graphic equalizer.

![Fig. 1. Neural Network](./figs/neuralNet.png) 

The band filter coefficients can then be quickly and easily computed using closed-form formulas. The cascade filter structure used is shown in Fig. 2, where $G_1, G_2, ..., G_M$ are the optimized filter gains calculated using the neural network, adn $G_0$ is the product of the scaling coefficients of the EQ band filters.

![Fig. 2.Cascade graphic EQ structure](./figs/CascadeGEQ.png) 

This work turns, for the first time, the accurate graphic equalization design into a feedforward calculation without matrix inversion or iterations. The filter gain control using the neural network reduces the computing time by 99.6% in comparison to the least-squares design method it is imitating and contributes an approximation error of less than 0.1 dB. The resulting neurally controlled graphic equalizer will be highly useful in various audio and music processing applications, which require time-varying equalization. 

## Instructions to run the Matlab Scripts
The Matlab scripts for the Neurally controlled graphic equalizer can be found in the folder NGEQscripts. The folder includes the following files:

    - GEQfilter.m
    - NGEQ_MatlabNetworkObj.mat
    - NGEQ_parameters.mat
    - NGEQ.m 
    - NGEQfilterAudio.m
    - pareq2.m
    - plotNGEQ.m

### Run the example
To run an example design of the neurally controlled graphic equalizer, run the file *plotNGEQ*, which designs and plots the EQ with given user-set target gains (zig zag by default).

The script uses *NGEQ*, which loads the neural net parameters (*NGEQ_parameters*), to run the filter optimization calculation. Then the *GEQfilter* takes these optimized filter gains and designs the needed equalization band filters using *pareq2*.

### Other matlab files
*NGEQ_MatlabNetworkObj* includes Matlab's net object that has all the required information for Matlab to run the neural network. To use the net object, just give the object the user-set target gains and it outputs the optimized filter gains, e.g., 

```matlab
filterGains = net(12*ones(10,1)).
```

*NGEQfilterAudio.m* can be used to filter audio by giving it the input audio sample and the user-set target gains.