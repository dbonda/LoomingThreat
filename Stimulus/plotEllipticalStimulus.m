function plotEllipticalStimulus(hAxes, shapeColor, fps)
% PLOTELLIPTICALSTIMULUS  Plots a filled ellipse on a given axes element
% 
% This function expects two parameters:
%  - hAxes: The handle object to the axes the ellipse should be plotted
%  - shapeColor: The filling color (RGB values) of the ellipse presented as a
%  3-element row vector each value in the range between 0 and 1
%  - fps: The number of frames per stimulus
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


% Check number of input arguments
minInputs = 3;
maxInputs = 3;
narginchk(minInputs,maxInputs)

degreeStep = 1;
radStep    = degreeStep * (pi/180);


% Create vector for angles in radian
phi = 0:radStep:2*pi;
numSegments = length(phi);

% Generate the values for x- and y-coordinates of a unit-circle
x_unit = cos(phi);
y_unit = sin(phi);

% Generate the x- and y-coordinates for scaled circles
x = zeros(fps, numSegments);
y = zeros(fps, numSegments);

for cntr = 1:1:fps
    x(cntr, :) = x_unit .* cntr;
    y(cntr, :) = y_unit .* cntr;
end


cla(hAxes);
% Display a circle with radius 0 to init the plotting
hPatch = fill(hAxes, 0, 0, shapeColor, 'EdgeColor', shapeColor);

% Fixate the axis of the plot
hAxes.XLim = [-fps fps];
hAxes.YLim = [-fps fps];

% Make the axis invisible
hAxes.Visible = 'off';

% Force MATLAB to draw everything and wait to finish it
drawnow;

% Set aspect ratio to an ellipse
pbaspect([2 1 1]);

% Now plot the different circles
for cntr = 1:1:fps
    % Update figure with current circle
    set(hPatch, 'XData', x(cntr, :), 'YData', y(cntr, :));
    
    % Force MATLAB to draw everything and wait to finish it
    drawnow;
end

end % function