%
%> @file kVIS_uiSetupTabData.m
%> @brief Create UI for Data Tab
%
%
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

%
%> @brief Create UI for Data Tab
%>
%> @param GUI handle structure
%> @param Parent handle
%>
%> @retval GUI handle structure
%
function handles = kVIS_uiSetupTabData(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

if ispc
    ftSize = 13;
else
    ftSize = 16;
end

handles.uiTabData.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Data');

data_tab_hbox = uix.HBoxFlex('Parent', handles.uiTabData.tabHandle);

data_tab_left = uix.VBox('Parent',data_tab_hbox,'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);
data_tab_right = uix.VBox('Parent', data_tab_hbox,'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);

data_tab_hbox.Widths = [getpref('kVIS_prefs','uiDataChannelBoxWidth') -1];

% left panel - data channels
handles.uiTabData.channelListboxLabel = uicontrol(data_tab_left,'Style','text',...
    'String','Data Channels',...
    'Units','normalized',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'), 'Foregroundcolor','w','FontSize',ftSize);

channelListBoxMenu = uicontextmenu;
handles.uiTabData.channelListBoxMenu1 = uimenu(channelListBoxMenu, 'Label', 'Show display names (default)',...
    'Checked', 'on', 'Callback', {@kVIS_updateChannelList_Callback, 0});
handles.uiTabData.channelListBoxMenu2 = uimenu(channelListBoxMenu, 'Label', 'Show original names',...
    'Checked', 'off', 'Callback', {@kVIS_updateChannelList_Callback, 1});
handles.uiTabData.channelListBoxMenu3 = uimenu(channelListBoxMenu, 'Label', 'Copy to clipboard',...
    'Callback', @kVIS_channelID2Clipboard_Callback);
handles.uiTabData.channelListBoxMenu4 = uimenu(channelListBoxMenu, 'Label', 'Export to workspace',...
    'Callback', @kVIS_channelData2Workspace_Callback);
handles.uiTabData.channelListBoxMenu5 = uimenu(channelListBoxMenu, 'Label', 'Timing check',...
    'Callback', @kVIS_groupTimingCheck_Callback);
% handles.uiTabData.channelListBoxMenu6 = uimenu(channelListBoxMenu, 'Label', 'Group time offset',...
%     'Callback', @kVIS_groupTimeOffset_Callback);

handles.uiTabData.channelListbox = uicontrol(data_tab_left,...
    'Style','listbox',...
    'String','',...
    'FontName','Monospaced',...
    'Callback',@kVIS_channelList_Callback,...
    'UIContextMenu', channelListBoxMenu);

data_tab_left.Heights = [30 -1];

% right panel - data sets and groups

uicontrol(data_tab_right,'Style','text',...
    'String','Data Sets',...
    'Units','normalized',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'), 'Foregroundcolor','w','FontSize',ftSize);

dataSetListBoxMenu = uicontextmenu();
uimenu(dataSetListBoxMenu,'Text','Rename Dataset','Callback', @kVIS_menuRenameDataSet_Callback);
uimenu(dataSetListBoxMenu,'Text','Time offset','Callback', @kVIS_menuDataSetTimeOffset_Callback);

handles.uiTabData.dataSetList = uicontrol(data_tab_right,...
    'Style', 'listbox', ...
    'Units', 'normalized', ...
    'Position', [0.025,0.05,0.6,0.9], ...
    'String', '', ...
    'FontName', 'Monospaced', ...
    'Tag', 'flight_list', ...
    'Interruptible', 'off', ...
    'BusyAction', 'queue', ...
    'Callback', @kVIS_dataSetList_Callback,...
    'UIContextMenu', dataSetListBoxMenu);

uicontrol(data_tab_right,'Style','text',...
    'String','Data Groups',...
    'Units','normalized',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'), 'Foregroundcolor','w','FontSize',ftSize);

% Requires
% https://de.mathworks.com/matlabcentral/fileexchange/66235-widgets-toolbox
handles.uiTabData.groupTree = uiw.widget.Tree( ...
    'Parent', data_tab_right, ...
    'Units', 'normalized', ...
    'BackgroundColor', getpref('kVIS_prefs','uiBackgroundColour'), ...
    'FontUnits', 'points',...
    'FontName', 'Monospaced', ...
    'FontSize', getpref('kVIS_prefs','defaultGroupTreeFontSize'), ...
    'RootVisible', false ,...
    'SelectionChangeFcn', {@kVIS_updateChannelList_Callback, 0}, ...
    'NodeExpandedCallback', @kVIS_treeExpandNode_Callback, ...
    'NodeCollapsedCallback', @kVIS_treeCollapseNode_Callback);

uix.Empty('Parent', data_tab_right);

search_bar_field = uix.HBox('Parent', data_tab_right,'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'), 'Padding', 1);

data_tab_right.Heights = [30 -1 30 -3 5 30];

handles.uiTabData.groupSearchString = uicontrol(search_bar_field,...
    'Style', 'edit', 'String', 'Search', 'HorizontalAlignment', 'left',...
    'KeyReleaseFcn', @kVIS_searchField_Callback);

uicontrol(search_bar_field, 'Style', 'pushbutton', 'String', 'Search',...
    'Callback', @kVIS_searchBtn_Callback);

search_bar_field.Widths = [-1 50];