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

function kVIS_deleteWP_Callback(hObject, ~)
%
% delete event(s) from list
%

handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

%
% get selected row(s) from user data field
%
EventID = eventList.UserData.rowSelected;

%
% get current event list
%
[fds, name] = kVIS_getCurrentFds(hObject);

%
% remove entries from list
%
eList = kVIS_trimEventList(EventID, fds.eventList);

%
% save modified list and update UI
%
fds.eventList = eList;

% fds = kVIS_eventTimeSeries(hObject, fds);

kVIS_updateDataSet(hObject, fds, name)
end

