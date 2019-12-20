function kVIS_dataTimerFcn(hObject, event)
%
% Replay timer callback
%

% https://de.mathworks.com/matlabcentral/answers/302939-accessing-timer-userdata-fields
Data = hObject.UserData;

i = Data.currentStep;

%
% Call BSP timer function
%
[currentTime, sampleNo] = BSP_replayTimerUpdateFcn(Data, i);

%
% Update time indicator line
%
Data.lineHandle.XData = [currentTime currentTime];

%
% Next timestep
%
Data.currentStep = Data.currentStep + round(1 / (Data.updateFrequency * Data.sampleRate));

%
% Stop playback at end of data
%
if Data.currentStep >= sampleNo
    kVIS_dataReplayStop_Callback(hObject, []);
    msgbox('End of Data Playback.')
    return
end

hObject.UserData = Data;
end



