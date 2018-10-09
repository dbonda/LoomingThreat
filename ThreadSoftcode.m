function ThreadSoftcode( bytein )

addpath('Stimulus');
global TaskParameters;

% Get values for plotting the stimulus
defaultBgColor = TaskParameters.defaultBgColor;
shelterBgColor = TaskParameters.shelterBgColor;
spotColor      = TaskParameters.spotColor;
fps            = TaskParameters.spotFps;

% Get handles to figures etc.
hFig    = TaskParameters.hFig;
hJFrame = TaskParameters.hJFrame;
hAxes   = TaskParameters.hAxes;


switch bytein
    case 1
        disp('Show stimulus');
        plotEllipticalStimulus(hAxes, spotColor, fps);
        pause(0.2);
        plotEllipticalStimulus(hAxes, spotColor, fps);
        pause(0.2);
        plotEllipticalStimulus(hAxes, spotColor, fps);
        pause(0.2);
        plotEllipticalStimulus(hAxes, spotColor, fps);
        pause(0.2);
        plotEllipticalStimulus(hAxes, spotColor, fps);
        pause(0.2);
    case 2
        disp('Show shelter');
        clearScreen(hFig, hJFrame, hAxes, shelterBgColor);
    case 3
        disp('Clear sky');
        clearScreen(hFig, hJFrame, hAxes, defaultBgColor);
end % switch

end % function

