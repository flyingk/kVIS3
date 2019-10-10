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

function kVIS_zoomOutButton_Callback(hObject, events, reset)

% handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

h = kVIS_dataViewerGetActivePanel;

if strcmp(h.Tag, 'mapplot')
    
    ax = findobj(h, 'Type', 'axes');
    track = findobj(ax, 'Type', 'Scatter');
    xlim(ax, [min(track.XData)-abs(min(track.XData))*0.000005 max(track.XData)+abs(max(track.XData))*0.000005])
    ylim(ax, [min(track.YData)-abs(min(track.YData))*0.000005 max(track.YData)+abs(max(track.YData))*0.000005])
    update_google_map(hObject, events);
    
else
    
    kVIS_clearPlotLim_Callback(hObject, [], 'all');
    
end


end

