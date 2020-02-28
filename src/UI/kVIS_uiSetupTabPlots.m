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

function [handles] = kVIS_uiSetupTabPlots(handles, uiTabGroupRight)

if ~nargin
    close all;
    clc
    kVIS3;
    return;
end

%
% tab
%
handles.uiTabPlots.tabHandle = uitab('Parent', uiTabGroupRight, 'Title', 'Plots');
%
% split tab in vertical strips
%
plot_tab_vbox = uix.VBox ('Parent', handles.uiTabPlots.tabHandle,...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),'Padding',8);
%
% tab label string
%
uicontrol(plot_tab_vbox,'Style','text',...
    'String','Custom Plots',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'),...
    'Foregroundcolor','w','FontSize',16);
%
% button strip
%
rbn_plots_pane = uix.HButtonBox('Parent', plot_tab_vbox,...
    'HorizontalAlignment','right',...
    'Backgroundcolor',getpref('kVIS_prefs','uiBackgroundColour'));
%
% buttons
%
uicontrol(rbn_plots_pane, 'Style', 'pushbutton',...
    'TooltipString','Reload plot definitions provided by BSP',...
    'CData',imread('icons8-rotate-36.png'),...
    'Callback', @kVIS_updateCustomPlotList_Callback);

uix.Empty('Parent', rbn_plots_pane);
uix.Empty('Parent', rbn_plots_pane);

% uicontrol(rbn_plots_pane, 'Style', 'pushbutton',...
%     'String','Plot all',...
%     'Callback',@generate_all_custom_plots_Callback,...
%     'Enable', 'off');

uix.Empty('Parent', rbn_plots_pane);

handles.uiTabPlots.plotsUseLimitsBtn = uicontrol(rbn_plots_pane,...
    'Style', 'togglebutton',...
    'CData',imread('use_limits.png'),...
    'TooltipString','Use X-Limits as plot boundaries',...
    'TooltipString','Use Data Range limits or plot full length',...
    'Callback',@kVIS_customPlotsUseLimitsBtn_Callback);

uix.Empty('Parent', rbn_plots_pane);

uicontrol(rbn_plots_pane, 'Style', 'togglebutton',...
    'CData',imread('icons8-edit-36.png'),...
    'Tooltipstring','Open plot definition file for editing',...
    'Tag','editPlotDefBtn',...
    'Callback',{@kVIS_editCustomPlotDefBtn_Callback,0});

handles.uiTabPlots.editPlotDefBtn = 0;

rbn_plots_pane.ButtonSize = [50 50];

%
% plot list box
%
% handles.uiTabPlots.customPlotListBox = uicontrol(plot_tab_vbox,'Style','listbox',...
%     'String','Plot Definitions',...
%     'Callback', {@kVIS_customPlotList_Callback,[]},...
%     'FontSize',12);

handles.uiTabPlots.customPlotListBox = uiw.widget.Tree( ...
    'Parent', plot_tab_vbox, ...
    'Units', 'normalized', ...
    'BackgroundColor', getpref('kVIS_prefs','uiBackgroundColour'), ...
    'FontUnits', 'points',...
    'FontName', 'Monospaced', ...
    'FontSize', getpref('kVIS_prefs','defaultGroupTreeFontSize'), ...
    'RootVisible', false, ...
    'SelectionChangeFcn', {@kVIS_customPlotList_Callback,[]} ...
);

%
% format vertical box
%
plot_tab_vbox.Heights = [20 60 -1];
end

