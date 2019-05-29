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

function kVIS_newEvent_Callback(hObject, ~)
%
% add new event to list
%
handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

%
% suggest current xlim as event limits
%
xlim = kVIS_getDataRange(hObject, 'XLim');
%
% user input
%
eType = 'Manual';
eIn   = num2str(xlim(1));
eOut  = num2str(xlim(2));
eDesc = 'New Event';

s = inputdlg({'Type','In','Out','Description'}, 'Event edit:', 1, {eType, eIn, eOut, eDesc});

if isempty(s)
    return
end


[fds, name] = kVIS_getCurrentFds(hObject);

%
% find place in event list
%
rowNew = 1;

inTimes = cell2mat(eventList.Data(:,2));

if ~isempty(inTimes) % any events yet?
    
    eList = fds.eventList;
    
    rowNew = find(inTimes < str2double(s{2}), 1, 'last');
    
    if isempty(rowNew) % first entry - move all down
        
        rowNew = 1;
        
        eList = [eList(rowNew) eList(rowNew:end)];
        
    else
        rowNew = rowNew + 1;

        if rowNew > size(eList,2) % last entry - add to end
            
        else % somewhere in the middle - move later events down
            eList = [eList(1:rowNew) eList(rowNew:end)];
        end
    end
end

% fill new entry
eList(rowNew).type = s{1};
eList(rowNew).start= str2double(s{2});
eList(rowNew).end  = str2double(s{3});
eList(rowNew).description= s{4};
eList(rowNew).plotDef='';

fds.eventList = eList;

% fds = kVIS_eventTimeSeries(hObject, fds);

kVIS_updateDataSet(hObject, fds, name)
end

