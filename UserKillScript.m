function UserKillScript()

global TaskParameters;

if (ishandle(TaskParameters.hFig))
    close(TaskParameters.hFig);
end

end

