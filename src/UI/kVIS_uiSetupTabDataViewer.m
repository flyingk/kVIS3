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

function handles=kVIS_uiSetupTabDataViewer(handles, uiTabGroupLeft)

if ~nargin
    close all;
    kVIS3;
    return;
end

handles = kVIS_uiSetupDataViewerRibbonGroup(handles, handles.uiFramework.uiRibbonRight);

handles.uiTabDataViewer.tabHandle = uitab(uiTabGroupLeft,'Title','Data Viewer');
handles.uiFramework.listOfTabs = [handles.uiTabDataViewer.tabHandle];
handles.uiFramework.listOfTabsPlotFcn = {@kVIS_dataViewerChannelListAction};
%
% horizontal box
%
handles.uiTabDataViewer.DividerH = uix.HBoxFlex('Parent',handles.uiTabDataViewer.tabHandle,'Spacing',2);
%
% first column
%
handles.uiTabDataViewer.Divider = uix.VBoxFlex('Parent',handles.uiTabDataViewer.DividerH,'Spacing',2);
%
% plot style definitions
%
handles.uiTabDataViewer.plotStyles = data_viewer_options(handles.preferences);
%
% create first plot
%
kVIS_addPlotAxes(handles, 1);
end

function Style = data_viewer_options(preferences)

% DataViewer options
Style = struct();

% Axes style (any attributes understood by set(axes_handle, ...)).
Style.AxesB.XColor = 'w';
Style.AxesB.YColor = 'w';
Style.AxesB.GridColor = 'k';
Style.AxesB.MinorGridColor = 'k';
Style.AxesB.XMinorGrid  = 'on';
Style.AxesB.YMinorGrid  = 'on';
Style.AxesB.XGrid  = 'on';
Style.AxesB.YGrid  = 'on';

Style.AxesT.XColor = 'w';
Style.AxesT.YColor = 'w';
Style.AxesT.GridColor = 'k';
Style.AxesT.MinorGridColor = 'k';
Style.AxesT.XMinorGrid  = 'on';
Style.AxesT.YMinorGrid  = 'on';
Style.AxesT.XGrid  = 'on';
Style.AxesT.YGrid  = 'on';

% Style.Main.XAxis.Color  = 'w';
% Style.Main.YLAxis.Color = 'w';
% Style.Main.YRAxis.Color = 'w';
% 
% Style.Top.Axes.XGrid       = 'off';
% Style.Top.Axes.YGrid       = 'off';
% Style.Top.Axes.XMinorGrid  = 'off';
% Style.Top.Axes.YMinorGrid  = 'off';
% Style.Top.XAxis.Visible = 'off';
% Style.Top.YAxis.Visible = 'off';

% Line style (any attributes understood by set(line_handle, ...))
Style.Signal.LineStyle = '-';
Style.Signal.LineWidth = 0.5;

% Legend style (any attributes understood by set(legend_handle, ...))
%DV.Style.Legend.Interpreter = 'latex';
Style.Legend.FontSize = preferences.defaultLegendFontSize;

end