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

function kVIS_dataViewerAxesSelect_Callback(hObject, ~, selection)

handles = guidata(hObject);

switch selection
    
    case 0
        
        handles.uiTabDataViewer.axesLeftToggle.Value = 1;
        handles.uiTabDataViewer.axesLeftToggle.CData = imread('left_ax.png')-25;
        handles.uiTabDataViewer.axesRightToggle.Value = 0;
        handles.uiTabDataViewer.axesRightToggle.CData = imread('right_ax.png');
        handles.uiTabDataViewer.axesTopToggle.Value = 0;
        handles.uiTabDataViewer.axesTopToggle.CData = imread('top_ax.png');
        handles.uiTabDataViewer.axesTop2Toggle.Value = 0;
        handles.uiTabDataViewer.axesTop2Toggle.CData = imread('top_ax.png');
        
        handles.uiTabDataViewer.AxesSelector = 'main_left';
        
    case 1
        
        handles.uiTabDataViewer.axesLeftToggle.Value = 0;
        handles.uiTabDataViewer.axesLeftToggle.CData = imread('left_ax.png');
        handles.uiTabDataViewer.axesRightToggle.Value = 1;
        handles.uiTabDataViewer.axesRightToggle.CData = imread('right_ax.png')-25;
        handles.uiTabDataViewer.axesTopToggle.Value = 0;
        handles.uiTabDataViewer.axesTopToggle.CData = imread('top_ax.png');
        handles.uiTabDataViewer.axesTop2Toggle.Value = 0;
        handles.uiTabDataViewer.axesTop2Toggle.CData = imread('top_ax.png');

        handles.uiTabDataViewer.AxesSelector = 'main_right';
        
    case 2
        
        handles.uiTabDataViewer.axesLeftToggle.Value = 0;
        handles.uiTabDataViewer.axesLeftToggle.CData = imread('left_ax.png');
        handles.uiTabDataViewer.axesRightToggle.Value = 0;
        handles.uiTabDataViewer.axesRightToggle.CData = imread('right_ax.png');
        handles.uiTabDataViewer.axesTopToggle.Value = 1;
        handles.uiTabDataViewer.axesTopToggle.CData = imread('top_ax.png')-25;
        handles.uiTabDataViewer.axesTop2Toggle.Value = 0;
        handles.uiTabDataViewer.axesTop2Toggle.CData = imread('top_ax.png');
        
        handles.uiTabDataViewer.AxesSelector = 'top';
        
    case 3
        
        handles.uiTabDataViewer.axesLeftToggle.Value = 0;
        handles.uiTabDataViewer.axesLeftToggle.CData = imread('left_ax.png');
        handles.uiTabDataViewer.axesRightToggle.Value = 0;
        handles.uiTabDataViewer.axesRightToggle.CData = imread('right_ax.png');
        handles.uiTabDataViewer.axesTopToggle.Value = 0;
        handles.uiTabDataViewer.axesTopToggle.CData = imread('top_ax.png');
        handles.uiTabDataViewer.axesTop2Toggle.Value = 1; 
        handles.uiTabDataViewer.axesTop2Toggle.CData = imread('top_ax.png')-25;

        handles.uiTabDataViewer.AxesSelector = 'top2';
        
        disp('need to add indicator for new top axes mode...')
        
end

guidata(hObject, handles);

end