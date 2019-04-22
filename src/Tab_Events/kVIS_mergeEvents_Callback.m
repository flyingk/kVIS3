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

function kVIS_mergeEvents_Callback(hObject, ~)
%
% merge events
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

eList = fds.eventList;





startE = EventID(1);

stopE = EventID(end);


% copy stop time of stopE into startE stop time
eList(startE).type= 'merged';
eList(startE).end = eList(stopE).end;

%
% save modified list and update UI
%
fds.eventList = eList;

fds = kVIS_eventTimeSeries(hObject, fds);

kVIS_updateDataSet(hObject, fds, name)



% delete all events replaced

handles.uiTabEvents.eventTable.UserData.rowSelected = EventID(2:end);

guidata(hObject, handles)


kVIS_deleteEvent_Callback(hObject, []);
end

