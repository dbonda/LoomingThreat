function clearScreen(hFig, hJFrame, hAxes, clearColor)
% PLOTELLIPTICALSTIMULUS  Plots a filled ellipse on a given axes element
% 
% This function expects two parameters:
%  - hAxes: The handle object to the axes the ellipse should be plotted
%  - shapeColor: The filling color (RGB values) of the ellipse presented as a
%  3-element row vector each value in the range between 0 and 1
%  - fps: The number of frames per stimulus
% 
% Author:  Michael Wulf
%          Cold Spring Harbor Laboratory
%          Kepecs Lab
%          Cold Spring Harbor, NY, USA
%          wulf@cshl.edu
%          michael.wulf@gmail.com
%
% Date:    2018-10-08
% Version: 1.0.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

color = java.awt.Color(clearColor(1),...
                       clearColor(2),...
                       clearColor(3));
hJFrame.getRootPane.setBackground(color);

cla(hAxes);
set(hFig, 'Color', clearColor);
drawnow;

end

