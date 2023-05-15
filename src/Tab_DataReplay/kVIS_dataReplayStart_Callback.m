% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


function kVIS_dataReplayStart_Callback(hObject, ~)

[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    % reset toggle button
    hObject.Value = 0;
    return
end

Data = BSP_replayDataPrepareFcn2(fds);

xlim = kVIS_getDataRange(hObject, 'XLim');

pts = find(Data.Time > xlim(1) & Data.Time < xlim(2));

% open
ReplayMex(0,0,0);

% tx HB
ReplayMex(3,0,0);

% tx data
% ReplayMex(2, Data.VS(1:1000,:), Data.CTRL(1:1000,:));
ReplayMex(2, Data.VS(pts,:), Data.CTRL(pts,:));

% close
ReplayMex(1,0,0);

return

%
% Restart playback from pause?
%
t  = timerfind('Tag','HeartbeatTimer');
t2 = timerfind('Tag','DataTimer');

if ~isempty(t)
    
    start(t)
    start(t2)
    
    pauseBtn = findobj('Tag','pausePlaybackToggle');
    pauseBtn. Value = 0;
    
    disp('Restart')
    return
end

%
% Start from scratch
%
[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    % reset toggle button
    hObject.Value = 0;
    return
end

%
% Create time indicator line
%
targetPanel = kVIS_dataViewerGetActivePanel();

axesHandle = targetPanel.axesHandle;

hold(axesHandle, 'on');

xlim = kVIS_getDataRange(hObject, 'XLim');
ylim = kVIS_getDataRange(hObject, 'YLim');

if isnan(ylim)
    current_lines = kVIS_findValidPlotLines(axesHandle);
    
    if ~isempty(current_lines)
        ylim(1) = min(arrayfun(@(x) x.UserData.yMin, current_lines));
        ylim(2) = max(arrayfun(@(x) x.UserData.yMax, current_lines));
    else
        % nothing plotted, so create empty time indicator plot
        ylim = [0 1];
        axesHandle.XLim = xlim;
    end
end

lineHandle = line(axesHandle, [xlim(1) xlim(1)], ylim, 'Color', 'r', 'LineWidth', 2.0);


%
% Open UDP connection
%
ip = getpref('kVIS_prefs','dataReplayTargetIP');

if ~isempty(ip)
    BSP_dataReplayMex('UDP_Init', ip)
else
    errordlg('Replay IP address invalid...')
    return
end

%
% heartbeat message @ 1Hz
%
t = timer('Period', 1, 'TasksToExecute', Inf, ...
          'ExecutionMode', 'fixedRate', 'Tag', 'HeartbeatTimer');

t.TimerFcn = @kVIS_heartbeatTimerFcn;

start(t)

%
% data messages @ 10Hz
%
updateFrequency = getpref('kVIS_prefs','dataReplaySpeed');

t2 = timer('Period', 1/updateFrequency, 'TasksToExecute', Inf, ...
          'ExecutionMode', 'fixedRate', 'Tag', 'DataTimer');

t2.TimerFcn = @kVIS_dataTimerFcn;

%
% save data in timer user data
%
Data = BSP_replayDataPrepareFcn(fds);
Data.currentStep = 1;
Data.lineHandle = lineHandle;
Data.updateFrequency = updateFrequency;
Data.sampleRate = mean(diff(Data.Time));

t2.UserData = Data;

start(t2)

end


