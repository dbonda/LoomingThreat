function Threat01
%THREAT01 Summary of this function goes here
%   Detailed explanation goes here


% This protocol introduces a naive mouse to water available in ports 1 and 3. 
% Written by Josh Sanders, 5/2015.
%
% SETUP
% You will need:
% - A Bpod MouseBox (or equivalent) configured with 3 ports.
% - Place masking tape over the center port (Port 2).

clc;

global BpodSystem
global TaskParameters

addpath('Stimulus');

%% Define parameters
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
if isempty(fieldnames(S))  % If settings file was an empty struct, populate struct with default settings
    S.GUI.CurrentBlock = 1; % Training level % 1 = Direct Delivery at both ports 2 = Poke for delivery
    S.GUI.RewardAmount = 5; %ul
    S.GUI.PortOutRegDelay = 0.5; % How long the mouse must remain out before poking back in
end

% Initialize parameter GUI plugin
BpodParameterGUI('init', S);

%% Define trials
numTrials = 500;
BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.

% Specify the Softcode callback function that will be executed and trigger 
% the stimulus generation...

BpodSystem.SoftCodeHandlerFunction = 'ThreadSoftcode';

%% Set parameters for controlling stimulus
TaskParameters.contrastLevel  = 1;
TaskParameters.defaultBgColor = 1/255 .* [224, 224, 224];
TaskParameters.shelterBgColor = 1/255 .* [  0,   0,   0];
TaskParameters.spotColor      = (1 - TaskParameters.contrastLevel) * TaskParameters.defaultBgColor;
TaskParameters.spotFps        = 15;

TaskParameters.hFig    = 0;
TaskParameters.hJFrame = 0;
TaskParameters.hAxes   = 0;

% Init the second screen
[hFig, hJFrame, hAxes] = initScreen(2, TaskParameters.defaultBgColor);
TaskParameters.hFig    = hFig;
TaskParameters.hJFrame = hJFrame;
TaskParameters.hAxes   = hAxes;


%% Initialize plots
% TrialType Outcome Plot (displays each future trial type, and scores completed trials as correct/incorrect
BpodSystem.ProtocolFigures.OutcomePlotFig = figure('Position', [200 200 1000 200],'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
BpodSystem.GUIHandles.OutcomePlot = axes('Position', [.075 .3 .89 .6]);
%TrialTypeOutcomePlot(BpodSystem.GUIHandles.OutcomePlot,'init',TrialTypes);
% Bpod Notebook (to record text notes about the session or individual trials)
BpodNotebook('init');

%% Main trial loop
for currentTrial = 1:numTrials
    S = BpodParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    
    sma = NewStateMatrix(); % Assemble state matrix
    sma = AddState(sma, 'Name', 'Start', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1In', 'Beam1Broken', 'Port2In', 'Beam2Broken'},...
        'OutputActions', {}); 
    sma = AddState(sma, 'Name', 'Beam1Broken', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1In', 'Beam1Broken', 'Port2In', 'Threat'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'Beam2Broken', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1In', 'Beam1Broken'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'Threat', ...
        'Timer', 1,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions', {'SoftCode', 1 }); 
    
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
    if ~isempty(fieldnames(RawEvents)) % If trial data was returned
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Computes trial events from raw data
        BpodSystem.Data = BpodNotebook('sync', BpodSystem.Data); % Sync with Bpod notebook plugin
        BpodSystem.Data.TrialSettings(currentTrial) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
        %BpodSystem.Data.(currentTrial) = TrialTypes(currentTrial); % Adds the trial type of the current trial to data
        %UpdateOutcomePlot(TrialTypes, BpodSystem.Data);
        SaveBpodSessionData; % Saves the field BpodSystem.Data to the current data file
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.BeingUsed == 0
        return
    end
end

if (ishandle(TaskParameters.hFig))
    close(TaskParameters.hFig);
end


function UpdateOutcomePlot(TrialTypes, Data)
% Determine outcomes from state data and score as the SideOutcomePlot plugin expects
    % global BpodSystem
    % Outcomes = zeros(1,Data.nTrials);
    % for x = 1:Data.nTrials
    %     if ~isnan(Data.RawEvents.Trial{x}.States.Drinking(1))
    %         Outcomes(x) = 1;
    %     else
    %         Outcomes(x) = 3;
    %     end
    % end
    % TrialTypeOutcomePlot(BpodSystem.GUIHandles.OutcomePlot,'update',Data.nTrials+1,TrialTypes,Outcomes);


