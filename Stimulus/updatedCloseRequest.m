function updatedCloseRequest(hObject, event, jFrame)
% UPDATEDCLOSEREQUEST  Add. callback for close event to close also a jFrame
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

% Check if jFrame exists in the current scope
if (exist('jFrame', 'var'))
    % Check if jFrame is an object of class javax.swing.JFrame
    if strcmpi(class(jFrame), 'javax.swing.JFrame')
        % Close the jFrame window!
        dispose(jFrame);
    end
end

% Close the original MATLAB window
delete(hObject);
end

