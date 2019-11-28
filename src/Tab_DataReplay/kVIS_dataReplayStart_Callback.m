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

DAT = kVIS_fdsGetGroup(fds, 'SIDPAC_fdata');


lat = kVIS_fdsGetChannel(fds, 'Default_Group','PhiGeo_INS3');
lon = kVIS_fdsGetChannel(fds, 'Default_Group','LambdaGeo_INS3');
h   = kVIS_fdsGetChannel(fds, 'Default_Group','HGeo_INS3');
h = h - 3.5;

cl   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Canard L');
cr   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Canard R');
wl   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Flap L');
wr   = kVIS_fdsGetChannel(fds, 'SIDPAC_fdata','Flap R');



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
    
    ylim(1) = min(arrayfun(@(x) x.UserData.yMin, current_lines));
    ylim(2) = max(arrayfun(@(x) x.UserData.yMax, current_lines));
end

lineHandle = line(axesHandle, xlim, ylim, 'Color', 'r', 'LineWidth', 2.0);


%
% Open UDP connection
%
kVIS_dataReplayMex('UDP_Init')

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
t2 = timer('Period', 1/10, 'TasksToExecute', Inf, ...
          'ExecutionMode', 'fixedRate', 'Tag', 'DataTimer');

t2.TimerFcn = @kVIS_dataTimerFcn;

% save data in timer user data
Data.DAT = DAT;
Data.LLA = [lat, lon, h];
Data.CTRL= [cl, cr, wl, wr];
Data.currentStep = 1;
Data.lineHandle = lineHandle;

t2.UserData = Data;

start(t2)

end


