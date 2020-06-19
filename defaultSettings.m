% Default Settings for runObserverModels
%% Task related parameters
stt.dsp = 5; % true disparity in pixels
stt.sz1 = 150; stt.sz2 = 150; % image size, rows and columns, must be even
stt.phwl=10; % half width of the left image patch (bold l), patch size is 2*phwl+1, must be even
stt.prw = 50; % the maximum possible disparity in pixels, must be positive, the range automatically will cover the negative,
% total search window on disparities have a length of 2*prw+1
stt.ntrl=10000; % number of trials

% check to see if the image size big enough for given patch size and search
% window on disparities.
if stt.prw+stt.phwl+1>(stt.sz1/2)
    disp('Error: Search range and patch size requires a bigger image')
end

%% Texture parameters
stt.TextureType=1; % 1 for binary texture, 2 for white texture, 3 for 1/f texture
stt.optionalplotForTextures=0; % figures of the textures without any surrounding background
stt.optionalplotForStereogram=0; % figures of the textures with surrounding background

% binary texture specific parameters
stt.p=0.1; % success rate of Bernoulli Distribution, p
stt.SucessA=1; % if Bernoulli trial turns out to be successful, then the gray value that pixel will be set to, s_h
stt.NoSucessA=0; % if Bernoulli trial turns out to be not successful, then the gray value that pixel will be set to, s_l
% white texture specific parameters
stt.sgt=1; % the standard Deviation of the gaussian distrubtion that generates the white textures sigma_s
% 1/f texture specific parameters
stt.sgt=1; % the standard Deviation of the gaussian distrubtion that generates the 1/f textures sigma_s

%% Noise parameters
stt.noiseType=1; % 1 for Gaussian Noise, 2 for 1/f Noise
stt.sgn = 0.5;   % noise standard deviation, sigma_n
stt.optionalplotForPatches1=0; % figures of the left and right images without background, the left patch and right image search region shown in blue
stt.optionalplotForPatches2=0; % figures of the left and right images with background, the left patch and right image search region shown in blue

%% Model parameters
stt.mdls=[1 2 ]; % a vector specifies which models will be simulated
% 1 the ideal observer for binary textures in Gaussian noise
% 2 the ideal observer for white textures in Gaussian noise

% Note that we assumed that the ideal observers know the true parameters of
% the distributions so this section set these parameters. However, this
% section also allows you to simulate sub-optimal models if needed.

% binary texture ideal observer parameters
stt.pModel=stt.p; %success rate of Bernoulli Distribution, p
stt.SucessAModel=stt.SucessA; % if Bernoulli trial turns out to be successful, then the gray value that pixel will be set to, s_h
stt.NoSucessAModel=stt.NoSucessA; % if Bernoulli trial turns out to be not successful, then the gray value that pixel will be set to, s_l
stt.sgnModel2 = stt.sgn;   % noise standard deviation, sigma_n



% white texture ideal observer parameters
stt.sgtModel=stt.sgt; % the standard Deviation of the gaussian distrubtion that generates the white textures sigma_s
stt.sgnModel = stt.sgn;   % noise standard deviation, sigma_n



%% Extra Figures, for the Results
stt.optPlotDispPref=0; % figure of the disparity estimation in a single trial
stt.optPlotDec=0; % figure of histograms for disparity estimates

