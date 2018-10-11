function ThreatSoftcode( bytein )
%THREATSOFTCODE Bpod softcode handler function for this task
%   This function will be executed whenever MATLAB receives a softcode while 
%   running a Bpod task
%
% Authors: David Bonda
%          Michael Wulf
%          Cold Spring Harbor Laboratory
%          Kepecs Lab
%          One Bungtown Road
%          Cold Spring Harboor
%          NY 11724, USA
% 
% Date:    10/09/2018 
% Version: 1.0.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add the 'Stimulus' subfolder to tht path (temporarily)
addpath('Stimulus');

% Load global variables 
global TaskParameters % custom structure to store only task related variables

% Get values for plotting the stimulus
defaultBgColor = TaskParameters.defaultBgColor;
shelterBgColor = TaskParameters.shelterBgColor;
spotColor      = TaskParameters.spotColor;
fps            = TaskParameters.spotFps;
delay          = TaskParameters.interStimulusDelay;
repititions    = TaskParameters.stimulusRepetitions;

% Get handles to figures etc.
hFig    = TaskParameters.hFig;
hJFrame = TaskParameters.hJFrame;
hAxes   = TaskParameters.hAxes;

% Do the action corresponding to the softcode
switch bytein
    case 0
        % Do nothing
        
    case 1
        % Present the looming stimulus in the external figure
        for cnt = 1:1:repititions
            plotEllipticalStimulus(hAxes, spotColor, fps);
            pause(delay);
        end
        TaskParameters.screenInit = 3;
        
    case 2
        % Present the 'shelter' stimulus in the external figure
        clearScreen(hFig, hJFrame, hAxes, shelterBgColor);
        TaskParameters.screenInit = 2;
        
    case 3
        % Reset the external figure to the default background
        clearScreen(hFig, hJFrame, hAxes, defaultBgColor);
        TaskParameters.screenInit = 3;
        
end % switch

end % function

