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
%
% add button group
%
handles = kVIS_uiSetupDataViewerRibbonGroup(handles, handles.uiFramework.uiRibbonRight);
%
% add tab, register handle and event fcn
%
handles.uiTabDataViewer.tabHandle     = uitab(uiTabGroupLeft,'Title','Data Viewer');
handles.uiFramework.listOfTabs        = [handles.uiTabDataViewer.tabHandle];
handles.uiFramework.listOfTabsPlotFcn = {@kVIS_dataViewerChannelListAction};
%
% horizontal box
%
handles.uiTabDataViewer.DividerH = uix.HBoxFlex('Parent',handles.uiTabDataViewer.tabHandle,'Spacing',2);
%
% plot style definitions
%
handles.uiTabDataViewer.plotStyles = data_viewer_options();
end

function Style = data_viewer_options()

% DataViewer options
Style = struct();

% Axes style (any attributes understood by set(axes_handle, ...)).
Style.Axes.XColor = 'w';
Style.Axes.YColor = 'w';
Style.Axes.GridColor = 'k';
Style.Axes.MinorGridColor = 'k';
Style.Axes.XMinorGrid  = 'on';
Style.Axes.YMinorGrid  = 'on';
Style.Axes.XGrid  = 'on';
Style.Axes.YGrid  = 'on';

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
Style.Legend.FontSize = getpref('kVIS_prefs','defaultLegendFontSize');

end