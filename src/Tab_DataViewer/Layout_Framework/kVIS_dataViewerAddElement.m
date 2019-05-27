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

function kVIS_dataViewerAddElement(hObject, ~, newColumn)

handles = guidata(hObject);

l = kVIS_dataViewerGetActivePanel();

if isempty(l)
    % first column
    column = 1;
elseif ~isempty(newColumn)
    % newly added column
    column = newColumn;
else
    % same column as active panel
    column = l.gridLocation(2);
end

%
% add new panel as standard timeplot
%
np = newPanel(handles, column);

%
% add axes 
%
ax = axes('Parent', np, 'Units','normalized');

kVIS_axesResizeToContainer(ax)

kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.AxesB);

%
% set panel properties
%
np.axesHandle = ax;
np.gridLocation = [0, column]; % row can change by deleting panel... WIP
np.linkPending = false;
np.xLim = kVIS_getDataRange(hObject,'XLim');
np.yLim = kVIS_getDataRange(hObject,'YLim');

%
% make panel active
%
kVIS_dataViewerSwitchElement(np, [])
 
% 
% link axes time
% 
pp = findobj('Tag','timeplot');
if size(pp,1) > 1
    kVIS_dataRangeUpdate_Callback(gcf, [], 'XLim')
    kVIS_dataViewerLinkTimeAxes(handles, 'x');
end
end


function np = newPanel(handles, column)

%
% add new panel as standard timeplot
%
np = uipanel(...
    'Parent',handles.uiTabDataViewer.Divider(column),...
    'BackgroundColor',handles.preferences.uiBackgroundColour,...
    'Tag', 'timeplot',...
    'ButtonDownFcn', @kVIS_dataViewerSwitchElement,...
    'BorderType','line',...
    'BorderWidth', 2,...
    'HighlightColor',handles.preferences.uiBackgroundColour,...
    'SizeChangedFcn', @kVIS_panelSizeChanged_Callback);

%
% Panel new properties
%
addprop(np, 'axesHandle');  % save axes handle in panel
addprop(np, 'gridLocation');% save location of the panel in the grid
addprop(np, 'linkPending'); % link request
addprop(np, 'linkTo');      % link target
addprop(np, 'linkFrom');    % link source
addprop(np, 'xLim');
addprop(np, 'yLim');
addprop(np, 'xLimOld');
addprop(np, 'yLimOld');
p0 = addprop(np, 'plotChanged');
p0.SetObservable = true;
addprop(np, 'plotChangedListener');

%
% create panel context menu
%
np.UIContextMenu = kVIS_createPanelContextMenu(np);

end


function [ m ] = kVIS_createPanelContextMenu(panel)

m = uicontextmenu();

uimenu('Parent', m, 'Label', 'Panel Options', 'Enable', 'off');

uimenu( ...
    'Parent', m, ...
    'Label', 'Timeplot', ...
    'Checked','on',...
    'Separator','on',...
    'Callback', {@kVIS_panelContextMenuAction, panel} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'XY plot', ...
    'Callback', {@kVIS_panelContextMenuAction, panel}, ...
    'Enable', 'off');
uimenu( ...
    'Parent', m, ...
    'Label', 'Status flag plot', ...
    'Callback', {@kVIS_panelContextMenuAction, panel}, ...
    'Enable', 'off');
uimenu( ...
    'Parent', m, ...
    'Label', 'Frequency plot', ...
    'Callback', {@kVIS_panelContextMenuAction, panel} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Correlation plot', ...
    'Callback', {@kVIS_panelContextMenuAction, panel}, ...
    'Enable', 'off');
uimenu( ...
    'Parent', m, ...
    'Label', 'Map plot', ...
    'Callback', {@kVIS_panelContextMenuAction, panel}, ...
    'Enable', 'on');
uimenu( ...
    'Parent', m, ...
    'Label', 'Add margins', ...
    'Separator','on',...
    'Callback', {@kVIS_panelContextMenuAction, panel}, ...
    'Enable', 'off');
uimenu( ...
    'Parent', m, ...
    'Label', 'Delete panel', ...
    'Separator','on',...
    'Callback', {@kVIS_panelContextMenuAction, panel} ...
    );

end