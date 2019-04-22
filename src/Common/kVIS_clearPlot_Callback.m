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

function kVIS_clearPlot_Callback(hObject, ~)

handles = guidata(hObject);
%
% clear and reset axes (removes y right if active)
%
cla(handles.uiTabDataViewer.axesTop, 'reset');
cla(handles.uiTabDataViewer.axesBot, 'reset');

% tab sig proc - move to tab fcn later
cla(handles.uiTabSigProc.axesLeft, 'reset');
cla(handles.uiTabSigProc.axesRight, 'reset');
%
% reset button states
%
kVIS_holdButton_Callback(findobj('Tag', 'DefaultRibbonGroupHoldToggle'), [], 1);
kVIS_zoomButton_Callback(findobj('Tag','DefaultRibbonGroupZoomToggle'), [], 1);
kVIS_cursorButton_Callback(findobj('Tag','DefaultRibbonGroupCursorToggle'), [], 1);
kVIS_panButton_Callback(findobj('Tag','DefaultRibbonGroupPanToggle'), [], 1);
%
% reset to default axes
%
kVIS_dataViewerAxesSelect_Callback(hObject, [], 0)
%
% update plot callbacks (get modified by map view...)
%
handles.uiFramework.zoomHandle.ActionPreCallback = @kVIS_preZoom_Callback;
handles.uiFramework.zoomHandle.ActionPostCallback = @kVIS_postZoom_Callback;
handles.uiFramework.panHandle.ActionPostCallback = @kVIS_postPan_Callback;
%
% restore top axes to default
%
handles.uiTabDataViewer.Divider.Heights = [60 -1];

end
