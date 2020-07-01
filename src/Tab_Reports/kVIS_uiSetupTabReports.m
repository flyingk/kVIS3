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

function [handles] = kVIS_uiSetupTabReports(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% tab
%
handles.uiTabReports.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Reports');
%
% split tab in vertical strips
%
report_tab_vbox = uix.VBox ('Parent', handles.uiTabReports.tabHandle,...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);
%
% tab label string
%
uicontrol(report_tab_vbox,'Style','text',...
    'String','Data Reports',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),...
    'Foregroundcolor','w','FontSize',16);
%
% button strip
%
rbn_Reports_pane = uix.HButtonBox('Parent', report_tab_vbox,...
    'HorizontalAlignment','right',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'));
%
% buttons
%
uicontrol(rbn_Reports_pane, 'Style', 'pushbutton',...
    'TooltipString','Reload report definitions provided by BSP',...
    'CData',imread('icons8-rotate-36.png'),...
    'Callback', @kVIS_updateReportList_Callback);

uix.Empty('Parent', rbn_Reports_pane);
uix.Empty('Parent', rbn_Reports_pane);

uicontrol(rbn_Reports_pane,...
    'Style', 'togglebutton',...
    'CData',imread('use_limits.png'),...
    'TooltipString','Use Data Range limits or report full length',...
    'Tag','ReportsUseLimitsBtn',...
    'Callback',{@kVIS_ReportsUseLimitsBtn_Callback,0});

handles.uiTabReports.ReportsUseLimitsBtn = 0;

% uicontrol(rbn_Reports_pane,...
%     'Style', 'togglebutton',...
%     'CData',imread('icons8-target-36.png'),...
%     'TooltipString','Export snapshot data',...
%     'Tag','ReportsSnapshotsBtn',...
%     'Callback',{@kVIS_ReportsSnapshotsBtn_Callback,0});
% 
% handles.uiTabReports.ReportsSnapshotsBtn = 0;

uix.Empty('Parent', rbn_Reports_pane);

uicontrol(rbn_Reports_pane, 'Style', 'togglebutton',...
    'CData',imread('icons8-edit-36.png'),...
    'Tooltipstring','Open report definition file for editing',...
    'Tag','editReportDefBtn',...
    'Callback',{@kVIS_editReportDefBtn_Callback,0});

handles.uiTabReports.editReportDefBtn = 0;

rbn_Reports_pane.ButtonSize = [50 50];

%
% plot list box
%
handles.uiTabReports.reportListBox = uicontrol(report_tab_vbox,'Style','listbox',...
    'String','Report Definitions',...
    'Callback', {@kVIS_reportList_Callback},...
    'FontSize',12);

%
% format vertical box
%
report_tab_vbox.Heights = [20 60 -1];
end

