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

function [handles] = kVIS_uiSetupTabWaypoints(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% tab
%
handles.uiTabWP.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Waypoints');
%
% split tab in vertical strips
%
wp_tab_vbox = uix.VBox ('Parent', handles.uiTabWP.tabHandle,...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);
%
% tab label string
%
if ismac
    uicontrol(wp_tab_vbox,'Style','text',...
        'String','Waypoints',...
        'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),...
        'Foregroundcolor','w','FontSize',16);
else
    uicontrol(wp_tab_vbox,'Style','text',...
        'String','Waypoints',...
        'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),...
        'Foregroundcolor','w','FontSize',14);
end
%
% button strip
%
rbn_wp_pane = uix.HButtonBox('Parent', wp_tab_vbox,...
    'HorizontalAlignment','left',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'));
%
% buttons
%
uicontrol(rbn_wp_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-download-36.png'),...
    'TooltipString','Update/Import Waypoint List',...
    'Callback',@kVIS_importWP_Callback);

uix.Empty('Parent', rbn_wp_pane);


uicontrol(rbn_wp_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-plus-36.png'),...
    'TooltipString','Add Waypoint',...
    'Callback',@kVIS_newWP_Callback);

uicontrol(rbn_wp_pane, 'Style', 'togglebutton',...
    'CData',imread('icons8-edit-36.png'),...
    'TooltipString','Edit Waypoint',...
    'Callback',{@kVIS_wpEditToggle_Callback, 0});

uicontrol(rbn_wp_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-trash-can-36.png'),...
    'TooltipString','Delete Waypoint(s)',...
    'Callback',@kVIS_deleteWP_Callback);

uix.Empty('Parent', rbn_wp_pane);

uicontrol(rbn_wp_pane, 'Style', 'pushbutton',...
    'CData',imread('icons8-export-36.png'),...
    'TooltipString','Export Waypoint(s) as CSV file',...
    'Callback',@kVIS_eventWP_Callback);

rbn_wp_pane.ButtonSize = [50 50];

%
% waypoint table
%
wpTable = uitable(wp_tab_vbox);
wpTable.Units = 'normalized';
wpTable.ColumnName = { ...
    'ID',          ...1
    'Lat',         ...2
    'Lon',         ...3
    'Alt',         ...4
    'Radius',      ...5
    'Description', ...6
};
wpTable.ColumnWidth = {60 45 45 45 45 100};
wpTable.ColumnFormat = {'char', 'numeric', 'numeric', 'numeric', 'numeric', 'char'};
wpTable.RowStriping = 'on';
wpTable.FontName = 'Monospaced';
wpTable.ColumnEditable = [
    false, ... 1
    false, ... 1
    false, ... 1
    false, ... 1
    false, ... 1
];
wpTable.Enable = 'On';
wpTable.CellSelectionCallback = @kVIS_wpListCellSelect_Callback;

handles.uiTabWP.wpTable = wpTable;

% myhandles.imp_list_T_SelectedIndex = [];
handles.uiTabWP.wpTableColumns = struct( ...
    'ID',         ...1
    'Lat',        ...2
    'Lon',        ...3
    'Alt',        ...4
    'Radius',     ...5
    'Description' ...6
);

handles.uiTabWP.wpEditToggle = 0;
%
% format vertical box
%
wp_tab_vbox.Heights = [20 60 -1];
end

function kVIS_wpEditToggle_Callback(hObject, ~, reset)

handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

if hObject.Value == 1
    hObject.CData = imread('icons8-edit-36_p.png')-20;
    handles.uiTabWP.wpEditToggle = 1;
elseif hObject.Value == 0
    hObject.CData = imread('icons8-edit-36.png');
    handles.uiTabWP.wpEditToggle = 0;
end

guidata(hObject, handles);

end