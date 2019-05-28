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

function kVIS_addPlotColumn_Callback(hObject, ~)
%
% add a column to the grid and create first panel
%
handles = guidata(hObject);

% new column
cols = handles.uiTabDataViewer.DividerH.Contents;
nextCol = size(cols,1) + 1;

handles.uiTabDataViewer.Divider(nextCol) = uix.VBoxFlex('Parent',handles.uiTabDataViewer.DividerH,'Spacing',2);

guidata(hObject, handles);

% first panel
kVIS_dataViewerAddElement(hObject, [], nextCol);

end

