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

function kVIS_updateEventList(hObject, eventList, reset)
%
% Update UI event table from fds event list
%
handles = guidata(hObject);

if reset == true
    handles.uiTabEvents.eventTable.Data = [];
    return
end

if ~isstruct(eventList)
    disp('Bad event list. Aborting events...')
    return
end


DataMap = handles.uiTabEvents.eventTableColumns;

ColumnNames = fieldnames(DataMap);

Table = cell(numel(eventList), numel(ColumnNames));

for I = 1 : numel(ColumnNames)
    Name = ColumnNames{I};
    Table(:, DataMap.(Name)) = {eventList(:).(Name)};
end

handles.uiTabEvents.eventTable.Data = Table;
end
