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

function kVIS_eventListCellSelect_Callback(hObject, eventdata)
%
% focus on selected event OR edit event fields
%

%
% do not react to weird events
%
if isempty(eventdata.Indices)
    return
end

handles = guidata(hObject);
%
% check event edit toggle state
%
if handles.uiTabEvents.eventEditToggle == 0
    
    eventFocus(hObject, eventdata);
    
else
    
    eventEdit(hObject, eventdata);
    
end

% save selected row in user data
handles.uiTabEvents.eventTable.UserData.rowSelected = eventdata.Indices(:,1);

guidata(hObject, handles)
end

function eventFocus(hObject, eventdata)
%
% focus on selected event
%
handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

EventID = eventdata.Indices(1);
EventCol= eventdata.Indices(2);

in  = eventList.Data{EventID,2};
out = eventList.Data{EventID,3};

kVIS_setDataRange(hObject, 'XLim', [in out]);
kVIS_dataRangeUpdate_Callback(hObject, [], 'XLim')

%
% generate linked plot, if clicked on the Plot Def. field
%
if EventCol == 5 && ~isempty(eventList.Data{EventID,5})
    kVIS_customPlotList_Callback(hObject, [], eventList.Data{EventID,5})
end

end

function eventEdit(hObject, eventdata)
%
% edit selected event data
%
handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

EventID = eventdata.Indices(1);
EventCol= eventdata.Indices(2);


% edit event fields
if EventCol < 5 % string entries
    
    eType = eventList.Data{EventID, 1};
    eIn   = num2str(eventList.Data{EventID, 2});
    eOut  = num2str(eventList.Data{EventID, 3});
    eDesc = eventList.Data{EventID, 4};

    s = inputdlg({'Type','In','Out','Description'}, 'Event edit:', 1, {eType, eIn, eOut, eDesc});
    
    if isempty(s)
        return       
    end
    
    [fds, name] = kVIS_getCurrentFds(hObject);
    
    eList = fds.eventList(EventID);
    
    eList.type = s{1};
    eList.start= str2double(s{2});
    eList.end  = str2double(s{3});
    eList.description = s{4};
    
    fds.eventList(EventID) = eList;
    
    kVIS_updateDataSet(hObject, fds, name)
    
elseif EventCol == 5 % plot list
    
    % get list of loaded custom plot definitions
    BSP_Name = fieldnames(handles.uiTabPlots.CustomPlots);
    
    custom_plot_list = fieldnames(handles.uiTabPlots.CustomPlots.(BSP_Name{1}));
    
    [s, ok] = listdlg('PromptString', 'Select a Plot Definition for Event',...
        'ListString', custom_plot_list, 'SelectionMode', 'single');
    
    if ok == 0
        return       
    end
    
    [fds, name] = kVIS_getCurrentFds(hObject);
    
    eList = fds.eventList(EventID);
    
    eList.plotDef = custom_plot_list{s};
    
    fds.eventList(EventID) = eList;
    
    kVIS_updateDataSet(hObject, fds, name)
    
end

end