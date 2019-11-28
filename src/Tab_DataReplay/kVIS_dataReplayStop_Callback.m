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


function kVIS_dataReplayStop_Callback(hObject, ~)
%
% Stop and delete playback timers
%

t = timerfind('Tag','HeartbeatTimer');

if ~isempty(t)
    stop(t)
end

t2 = timerfind('Tag','DataTimer');

if ~isempty(t)
    stop(t2)
    
    Data = t2.UserData;
    delete(Data.lineHandle);
end

delete(timerfind)

%
% reset button states
%
pauseBtn = findobj('Tag','pausePlaybackToggle');
pauseBtn. Value = 0;

playBtn = findobj('Tag','startPlaybackToggle');
playBtn. Value = 0;

%
% Close network interface
%
kVIS_dataReplayMex('UDP_Close')
end

