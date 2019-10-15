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
% clear and reset axes
%
l = kVIS_dataViewerGetActivePanel();

if isempty(l)
    errordlg('No panel selected...')
    return
end

cla(l.axesHandle, 'reset');

kVIS_setGraphicsStyle(l.axesHandle, handles.uiTabDataViewer.plotStyles.AxesB);
kVIS_axesResizeToContainer(l.axesHandle);
%
% reset y axes limits
%
kVIS_setDataRange(hObject, 'YLim', []);
%
% reset button states
%
kVIS_holdButton_Callback(findobj('Tag', 'DefaultRibbonGroupHoldToggle'), [], 1);
kVIS_zoomButton_Callback(findobj('Tag','DefaultRibbonGroupZoomToggle'), [], 1);
kVIS_cursorButton_Callback(findobj('Tag','DefaultRibbonGroupCursorToggle'), [], 1);
kVIS_panButton_Callback(findobj('Tag','DefaultRibbonGroupPanToggle'), [], 1);
% %
% % update plot callbacks (get modified by map view...)
% %
% handles.uiFramework.zoomHandle.ActionPreCallback = @kVIS_preZoom_Callback;
% handles.uiFramework.zoomHandle.ActionPostCallback = @kVIS_postZoom_Callback;
% handles.uiFramework.panHandle.ActionPostCallback = @kVIS_postPan_Callback;

end
