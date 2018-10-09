function UserKillScript()
%USERKILLSCRIPT Execute some code when the user presses the Bpod stop button
%
% When the user presses the stop button, the additional/external figure
% that presents the stimulus should be closed...
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

% Get the global structure 'TaskParameters'
global TaskParameters;

% Check if the subfield 'hFig' is present and a handle to a figure
if ( isfield(TaskParameters, 'hFig') && ishandle(TaskParameters.hFig) )
    % Close the figure (and by that call the close-request callback function)
    close(TaskParameters.hFig);
end

end % function

