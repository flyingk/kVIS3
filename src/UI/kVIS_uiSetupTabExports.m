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

function [handles] = kVIS_uiSetupTabExports(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% tab
%
handles.uiTabExports.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Exports');
%
% split tab in vertical strips
%
export_tab_vbox = uix.VBox ('Parent', handles.uiTabExports.tabHandle,...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);
%
% tab label string
%
uicontrol(export_tab_vbox,'Style','text',...
    'String','Data Exports',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),...
    'Foregroundcolor','w','FontSize',16);
%
% button strip
%
rbn_exports_pane = uix.HButtonBox('Parent', export_tab_vbox,...
    'HorizontalAlignment','right',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'));
%
% buttons
%
uicontrol(rbn_exports_pane, 'Style', 'pushbutton',...
    'TooltipString','Reload plot definitions provided by BSP',...
    'CData',imread('icons8-rotate-36.png'),...
    'Callback', @kVIS_updateExportList_Callback);

uix.Empty('Parent', rbn_exports_pane);
uix.Empty('Parent', rbn_exports_pane);

uicontrol(rbn_exports_pane,...
    'Style', 'togglebutton',...
    'CData',imread('use_limits.png'),...
    'TooltipString','Use Data Range limits or export full length',...
    'Tag','exportsUseLimitsBtn',...
    'Callback',{@kVIS_exportsUseLimitsBtn_Callback,0});

handles.uiTabExports.exportsUseLimitsBtn = 0;

uicontrol(rbn_exports_pane,...
    'Style', 'togglebutton',...
    'CData',imread('icons8-target-36.png'),...
    'TooltipString','Export snapshot data',...
    'Tag','exportsSnapshotsBtn',...
    'Callback',{@kVIS_exportsSnapshotsBtn_Callback,0});

handles.uiTabExports.exportsSnapshotsBtn = 0;

uix.Empty('Parent', rbn_exports_pane);

uicontrol(rbn_exports_pane, 'Style', 'togglebutton',...
    'CData',imread('icons8-edit-36.png'),...
    'Tooltipstring','Open export definition file for editing',...
    'Tag','editExportDefBtn',...
    'Callback',{@kVIS_editExportDefBtn_Callback,0});

handles.uiTabExports.editExportDefBtn = 0;

rbn_exports_pane.ButtonSize = [50 50];

%
% plot list box
%
handles.uiTabExports.exportListBox = uicontrol(export_tab_vbox,'Style','listbox',...
    'String','Export Definitions',...
    'Callback', {@kVIS_exportList_Callback},...
    'FontSize',12);

%
% format vertical box
%
export_tab_vbox.Heights = [20 60 -1];
end

