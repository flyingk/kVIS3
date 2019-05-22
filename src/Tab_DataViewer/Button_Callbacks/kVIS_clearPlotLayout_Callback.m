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

function kVIS_clearPlotLayout_Callback(hObject, ~)

handles = guidata(hObject);

%
% delete listener objects for linked plots
%
l = findobj('Tag', 'fftplot');
if ~isempty(l)
    delete(l.plotChangedListener);
end

%
% remove all but first columns
%
e = handles.uiTabDataViewer.DividerH.Contents;

delete(e(2:end))

handles.uiTabDataViewer.Divider = handles.uiTabDataViewer.Divider(1);
%
% remove all but first panel in column one
%
e = handles.uiTabDataViewer.Divider.Contents;

delete(e(2:end))

e(1).Tag = 'timeplot';
e(1).BackgroundColor = handles.preferences.uiBackgroundColour;

guidata(hObject, handles);
end

