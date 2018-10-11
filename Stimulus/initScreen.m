function [hFig, hJFrame, hAxes] = initScreen(usedDisplay, bgColor)
% INITSCREEN  Initializing a figure without title bars etc. as a fullscreen plot
% 
% This function expects two parameters:
%  - usedDisplay: The display number (scalar) on which display/monitor the
%  fullscrren figure should be presented
%  - bgColor: The backgroud color (RGB values) of the figure presented as a
%  3-element row vector each value in the range between 0 and 1
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check output/input arguments
% START
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of output arguments
if nargout ~= 3
    error('InitScreen a to pass two output arguments (handle to figure and axes');
end

% Check number of input arguments
minInputs = 2;
maxInputs = 2;
narginchk(minInputs,maxInputs)

% Check argument usedDisplay
classes = {'double'};
attributes = {'size', [1,1], '>=', 0};
validateattributes(usedDisplay, classes, attributes);

% Check argument bgColor
classes = {'double'};
attributes = {'size', [1,3], '>=', 0, '<=', 1};
validateattributes(bgColor, classes, attributes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check output/input arguments
% END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Before doing anything, check the version of MATLAB
% This scriptmight not run on versions before MATLAB R2014b!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MLverStr  = version;
MLverCell = strsplit(MLverStr, '.');
MLver     = str2double([MLverCell{1} '.' MLverCell{2}]);
if (MLver < 8.4)
    MLverStr =['R' version('-release')];
    warnStr = 'This script was designed for MATLAB R2014b and later!';
    warnStr = [warnStr ' It might not work correctly for this version ('];
    warnStr = [warnStr MLverStr ')'];
    warning(warnStr);
    clear 'warnStr';
end
clear 'MLverStr';
clear 'MLverCell';
clear 'MLver';



% Importing Java libraries for controlling the stimulus presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import java.lang.*; % Basic Java stuff
import java.awt.*;  % Accessing AWT stuff


% Start doing stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the coordinates and resolution of all connected monitors
monitors = get(groot, 'MonitorPositions');

if ( size(monitors, 1) >= usedDisplay )
    figurePositions = monitors(usedDisplay, :);
else
    figurePositions = monitors(1, :);
end

% Create the main figure
hFig = figure('Name', 'Looming stimulus',...
    'NumberTitle', 'off',...
    'MenuBar', 'none',...
    'ToolBar', 'none',...
    'Color', bgColor...
    );
% "Hide" it somewhere outside the visible area but don't set the visible
% option to off! Otherwise the Java-based code will ot work anymore!
set(hFig, 'OuterPosition', [2 * figurePositions(3:4), figurePositions(3:4)]);

% Create an axes object in this figure that we can refer to
hAxes = axes(hFig, 'Color', bgColor, 'Visible', 'off');
% Call draw now, so that we can access all the Java objects
% They will only be accessible after the figure was drawn...
drawnow;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Java-based stuff to get rid of the window decoration etc                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the MATLAB figure's underlying jFrame object to copy all the
% attributes from
jFrame = get(handle(hFig), 'JavaFrame');

% Get the jFrame's window object
jWindow = jFrame.fHG2Client.getWindow;

% From this window object, get the content and root pane objects and title
jwContentPane = jWindow.getContentPane;
%jwRootPane    = jWindow.getRootPane;
jwTitle       = jWindow.getTitle;

% Create a completely new jFrame object that will display the original
% content - To be precise: the content will be linked to the original
% figure so that whenever there are changes in that they will be also
% "copied" to the new jFrame!
jFrame2 = javaObjectEDT(javax.swing.JFrame(jwTitle));

% Remove the "decoration" of the window -> titlebar etc
jFrame2.setUndecorated(true);

% Set the background color accordingly
color = java.awt.Color(bgColor(1),...
    bgColor(2),...
    bgColor(3));
jFrame2.getRootPane.setBackground(color);

% Specify the correct coordinates for the new figure (jFrame)
jPointLocation = java.awt.Point(figurePositions(1)-1, figurePositions(2)-1);
jFrame2.setLocation(jPointLocation);

% Set the jFrame's size to the specfied values
jFrame2.setSize(figurePositions(3), figurePositions(4));

% "Move" the content from the original MATLAB figure to the newly created
% jFrame figure
jFrame2.setContentPane(jwContentPane);

% Make the new JFrame visible
jFrame2.setVisible(true);

% change the callback for the close event so that the jFrame will be closed as well!
set(hFig, 'CloseRequestFcn',{@updatedCloseRequest, jFrame2});

hJFrame = jFrame2;

end
