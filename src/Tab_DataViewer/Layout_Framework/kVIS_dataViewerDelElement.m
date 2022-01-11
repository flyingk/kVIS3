% kVIS3 Data Visualisation
%
%> @file kVIS_dataViewerDelElement.m
%> @brief Delete a data viewer panel
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

%
%> @brief Delete a data viewer panel
%>
%> @param UI handles
%> @param Panel to delete
%
function kVIS_dataViewerDelElement(handles, panel)

if isempty(panel)
    panel = kVIS_dataViewerGetActivePanel();
end

% remove time axes links
kVIS_dataViewerLinkTimeAxes(handles, 'off');

% delete listener (if exists)
delete(panel.plotChangedListener);

% if link target, break link
if ~isempty(panel.linkFrom)
    delete(panel.linkFrom.plotChangedListener);
    panel.linkFrom.BackgroundColor = getpref('kVIS_prefs','uiBackgroundColour');
    panel.linkFrom.linkTo = [];
    panel.linkFrom = [];
    
end

% if link source, remove link
if ~isempty(panel.linkTo)
    rm(handles, panel.linkTo);
end

rm(handles, panel);

kVIS_dataViewerLinkTimeAxes(handles, 'x');
end


function rm(handles, panel)

% last plot in column -> remove column
if size(handles.uiTabDataViewer.Divider(panel.gridLocation(2)).Contents,1) == 1
    if panel.gridLocation(2) > 1
        delete(handles.uiTabDataViewer.Divider(panel.gridLocation(2)))
    else
        errordlg('Can''t delete last plot in first column.')
        return
    end
else
    delete(panel)
end

end