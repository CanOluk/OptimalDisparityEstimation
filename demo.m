% These two examples illustrates how to manipulate some major parameters
% like texture, noise type etc. that are set in the defaultSettings.m 
% and do simulations with runObserverModels.m.
%% First Example: Single Trial
% check texture, stimuli, and decision variables as a function of disparity in a single trial,

clear;clc;close all % clear everything
% load the default settings
defaultSettings 
% The code generates a struct variable called "stt". Fields of the struct
% specify parameters that can be changed. This code will set all the fields to
% their default values. To manipulate other parameters please see
% defaultSettings.m
stt.ntrl=1; % set number of trials to one 

% For the textures and stimuli, two types of stereo image pairs can be produced. One
% includes two regions "center and surround" that have two different levels of disparity. This image pair is 
% for demonstration only. The other image pair is of a texture region that
% has only a single disparity. This image pair is a example of the stimuli used for the simulations.
 
% Part 1: Default Binary Texture with Gaussian Noise

%1 for binary texture, 2 for white texture, 3 for 1/f texture
stt.TextureType=1; % set texture type to binary
stt.optionalplotForTextures=1; % let the code generate figures of textures without the surround
stt.optionalplotForStereogram=1; % let the code generate figures of textures with the surround

% 1 for White Noise, 2 for 1 over f Noise
stt.noiseType=1; % set noise to be a Gaussian
stt.sgn = 0.5; % set standard deviation of noise (Gaussian), sigma_n
stt.optionalplotForPatches1=1; % let the code generate figures of stimuli without the surround, the patches shown in blue
stt.optionalplotForPatches2=1; % let the code generate figures of stimuli with the surround, the patches shown in blue

% 1 the ideal observer for binary textures in Gaussian noise
% 2 the ideal observer for white textures in Gaussian noise
stt.mdls=[1]; % since the texture is binary, only the ideal observer for binary textures is simulated.

% if a parameter of noise distribution or i.i.d texture distribution is changed, 
% the parameter should be changed for the models so that it will use the correct one.
stt.sgnModel2 = stt.sgn; % set noise standard deviation to the correct value for the ideal observer for binary textures in Gaussian noise,

stt.optPlotDispPref=1; % let the code generate the figure of decision variables as a function of disparity in a single trial

% Input of runObserverModels.m is struct array which specifies parameters.
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);
% Each output is a vector of disparity estimates and each element of the vector
% is an estimate for a different trial.
% dcc, cross-correlation, dse, squared-error,
% dNcc, normalized cross-correlation, dop, the ideal for white tex,
% dccB,the ideal for binary tex
%% First Example (Part 2): Success Rate of the Bernoulli distribution (p)
clc;close all
stt.p=0.5; % set the success rate of Bernoulli Distribution, p (the default is 0.1)
stt.pModel=stt.p; % set the parameter for the ideal observer as well
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% First Example (Part 3): White texture
clc;close all
stt.TextureType=2; % set texture type to white
stt.sgn = 1; % increase the tandard deviation of noise (Gaussian), sigma_n
stt.mdls=[2]; % since the texture is white, only the ideal observer for white textures is simulated.
% set any parameters for the models that has been changed from the defult
stt.sgnModel= stt.sgn;  % set noise standard deviation to the correct value for the ideal observer for white textures in Gaussian noise,
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% First Example (Part 4): 1/F texture
clc;close all
stt.TextureType=3; % set texture type to 1/f
stt.mdls=[2 ]; % since the texture is 1/f, only the ideal observer for white textures is simulated.
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% Second Example: Histograms and 1000 trials, 
% check how disparity estimates are distributed

% In this demonstration, thousand trials are simulated and histogram of 
% disparity estimates are plotted while no plot is produced about a single
% trial. Note, scales of y-axis may be different for the different models. 
% The codes are very similar to example 1.

clear;clc;close all
defaultSettings % load the default settings
stt.ntrl=1000; %set number of trials to thousand

% Part 1: Default Binary Texture
stt.TextureType=1; % set texture type to binary

stt.noiseType=1; % set noise to be a Gaussian
stt.sgn = 1.3; % set noise standard deviation of Gaussian, sigma_n

stt.mdls=[1]; % since the texture is binary, only the ideal observer for binary textures is simulated.
stt.sgnModel2 = stt.sgn;   % set noise standard deviation to the correct value for the ideal observer for binary textures in Gaussian noise,

stt.optPlotDec=1; % let the code plot histograms of disparity estimates,

[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% Second Example (Part 2): Success Rate of the Bernoulli distribution (p)
clc;close all
stt.p=0.5; % set the success rate of Bernoulli Distribution, p (the default is 0.1)
stt.pModel=stt.p; % set the parameter for the ideal observer as well
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% Second Example (Part 3): White texture
clc;close all
stt.TextureType=2; % set texture type to binary
stt.sgn = 3; % increase the tandard deviation of noise (Gaussian), sigma_n
stt.mdls=[2 ]; % since the texture is white, only the ideal observer for white textures is simulated. 
% set any parameters for the models that has been changed from the defult
stt.sgnModel= stt.sgn;  % set noise standard deviation to the correct value for the ideal observer for white textures in Gaussian noise,
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);

%% Second Example (Part 4): 1/F texture
clc;close all
stt.TextureType=3; % set texture type to 1/f
stt.mdls=[2 ]; % since the texture is 1/f, only the ideal observer for white textures is simulated.
[dcc,dse,dNcc,dop,dccB] = runObserverModels(stt);