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

function [handles] = kVIS_uiSetupTabEvents(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% tab
%
handles.uiTabEvents.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Events');
%
% split tab in vertical strips
%
event_tab_vbox = uix.VBox ('Parent', handles.uiTabEvents.tabHandle,...
    'Backgroundcolor',handles.preferences.uiBackgroundColour,'Padding',8);
%
% tab label string
%
uicontrol(event_tab_vbox,'Style','text',...
    'String','Events',...
    'Backgroundcolor',handles.preferences.uiBackgroundColour,...
    'Foregroundcolor','w','FontSize',16);
%
% button strip
%
rbn_event_pane = uix.HButtonBox('Parent', event_tab_vbox,...
    'HorizontalAlignment','left',...
    'Backgroundcolor',handles.preferences.uiBackgroundColour);
%
% buttons
%
uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-download-36.png'),...
    'TooltipString','Update/Import Event List',...
    'Callback',@kVIS_importEvents_Callback);

uix.Empty('Parent', rbn_event_pane);


uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-plus-36.png'),...
    'TooltipString','Add Event',...
    'Callback',@kVIS_newEvent_Callback);

uicontrol(rbn_event_pane, 'Style', 'togglebutton',...
    'CData',imread('icons8-edit-36.png'),...
    'TooltipString','Edit Event',...
    'Callback',{@kVIS_eventEditToggle_Callback, 0});

uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-link-36.png'),...
    'TooltipString','Merge Events',...
    'Callback',@kVIS_mergeEvents_Callback);

uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-trash-can-36.png'),...
    'TooltipString','Delete Event(s)',...
    'Callback',@kVIS_deleteEvent_Callback);

% uix.Empty('Parent', rbn_event_pane);

% uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
%     'String','Plot E',...
%     'Callback',@tmp_Callback,...
%     'Enable', 'off');

rbn_event_pane.ButtonSize = [50 50];

uicontrol(rbn_event_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-export-36.png'),...
    'TooltipString','Export Event(s) as FDS file',...
    'Callback',[],'Enable','off');

%
% event table
%
eventTable = uitable(event_tab_vbox);
eventTable.Units = 'normalized';
eventTable.ColumnName = { ...
    'Type/ID',     ... 1
    'Start',       ... 2
    'End',         ... 3
    'Description', ... 4
    'Plot Def.'    ... 5
};
eventTable.ColumnWidth = {60 45 45 100};
eventTable.ColumnFormat = {'char', 'bank', 'bank','char'};
eventTable.RowStriping = 'on';
eventTable.FontName = 'Monospaced';
eventTable.ColumnEditable = [
    false, ... 1
    false, ... 1
    false, ... 1
    false, ... 1
    false, ... 1
];
eventTable.Enable = 'On';
eventTable.CellSelectionCallback = @kVIS_eventListCellSelect_Callback;

handles.uiTabEvents.eventTable = eventTable;

% myhandles.imp_list_T_SelectedIndex = [];
handles.uiTabEvents.eventTableColumns = struct( ...
    'type',        1, ...
    'start',       2, ...
    'end',         3, ...
    'description', 4, ...
    'plotDef',    5  ...
);

handles.uiTabEvents.eventEditToggle = 0;
handles.uiTabEvents.eventTimeSeries = []; % for visualising event locations
%
% format vertical box
%
event_tab_vbox.Heights = [20 60 -1];
end

function kVIS_eventEditToggle_Callback(hObject, ~, reset)

handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

if hObject.Value == 1
    hObject.CData = imread('icons8-edit-36_p.png')-20;
    handles.uiTabEvents.eventEditToggle = 1;
elseif hObject.Value == 0
    hObject.CData = imread('icons8-edit-36.png');
    handles.uiTabEvents.eventEditToggle = 0;
end

guidata(hObject, handles);

end