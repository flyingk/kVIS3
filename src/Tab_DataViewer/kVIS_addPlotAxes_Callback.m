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

function kVIS_addPlotAxes_Callback(hObject, ~)

handles = guidata(hObject);

%
% save plot layout
%
wd = handles.uiTabDataViewer.Divider.Widths;
hs = handles.uiTabDataViewer.Divider.Heights;

plts = length(wd) * length(hs);
%
% de-focus previous axes
%
l = findobj('Tag', 'plotPanel_active');

l.BackgroundColor = handles.preferences.uiBackgroundColour;
l.Tag = 'plotPanel';

%
% add new panel/axes
%
np = uipanel('Parent',handles.uiTabDataViewer.Divider,'BackgroundColor',handles.preferences.uiBackgroundColour + 0.15,...
    'Tag', 'plotPanel_active', 'ButtonDownFcn', @kVIS_plotPanelSelectFcn);

ax = axes('Parent', np, 'Units','normalized', 'Position',[0.05 0.06 0.9 0.9]);

kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.AxesB);

%
%
%
if length(handles.uiTabDataViewer.Divider.Contents) > plts
    handles.uiTabDataViewer.Divider.Widths = wd;
    handles.uiTabDataViewer.Divider.Heights = [hs; -1];
end
%
% copy data range to new axes
%
kVIS_dataRangeUpdate_Callback(hObject, [], 'XLim');
%
% link axes time
%
ax = findobj(handles.uiTabDataViewer.Divider, 'Type', 'axes');
linkaxes(ax,'x');
end

