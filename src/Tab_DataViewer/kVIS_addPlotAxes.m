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

function kVIS_addPlotAxes(handles, column)

%
% de-focus previous axes
%
l = findobj('Tag', 'plotPanel_active');

if ~isempty(l)
    l.BackgroundColor = handles.preferences.uiBackgroundColour;
    l.Tag = 'plotPanel';
end

%
% add new panel/axes
%
np = uipanel('Parent',handles.uiTabDataViewer.Divider(column),'BackgroundColor',handles.preferences.uiBackgroundColour + 0.15,...
    'Tag', 'plotPanel_active', 'ButtonDownFcn', @kVIS_plotPanelSelectFcn);

ax = axes('Parent', np, 'Units','normalized', 'Position',[0.05 0.06 0.9 0.9]);

kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.AxesB);
%
% save location of the panel in the grid
%
np.UserData.Column = column;
%
% default plot type
%
np.UserData.PlotType = 'standard';
%
% create context menu
%
np.UIContextMenu = kVIS_createPanelContextMenu(np);

%
% copy data range to new axes
%
% kVIS_dataRangeUpdate_Callback(hObject, [], 'XLim');
%
% link axes time
%
% ax = findobj(handles.uiTabDataViewer.Divider, 'Type', 'axes');
% linkaxes(ax,'x');
end


function [ m ] = kVIS_createPanelContextMenu(panel)
    % This function creates a context menu for a given Line object.
    % The menu displays some metadata helping to identify the line, and
    % provides some callback actions.

    m = uicontextmenu();

    % metadata section
%     uimenu('Parent', m, 'Label', sprintf('Type: %s', panel.UserData.PlotType), 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Units: %s' , strip(line.UserData.signalMeta.unit))       , 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Data Set: %s', strip(line.UserData.signalMeta.dataSet)), 'Enable', 'off');
%     if isstruct(line.UserData) && isfield(line.UserData, 'yyaxis')
%         uimenu('Parent', m, 'Label', sprintf('Y Axis: %s', line.UserData.yyaxis), 'Enable', 'off');
%     end

    uimenu( ...
        'Parent', m, ...
        'Label', 'Timeplot', ...
        'Callback', {@kVIS_panelContextMenuAction, panel} ...
        );
    uimenu( ...
        'Parent', m, ...
        'Label', 'XY plot', ...
        'Callback', {@kVIS_panelContextMenuAction, panel} ...
        );
    uimenu( ...
        'Parent', m, ...
        'Label', 'Frequency plot', ...
        'Callback', {@kVIS_panelContextMenuAction, panel} ...
        );
    uimenu( ...
        'Parent', m, ...
        'Label', 'Delete', ...
        'Callback', {@kVIS_panelContextMenuAction, panel} ...
        );

end