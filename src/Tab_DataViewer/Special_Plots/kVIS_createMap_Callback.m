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

function kVIS_createMap_Callback(hObject, ~)
% Function for plotting the flight path using plot_google_map
%
% matt & kai

% Work out which locs to plot (only plot what's zoomed in on)
handles = guidata(hObject);
%
% hide top axes
%
handles.uiTabDataViewer.Divider.Heights = [0 -1];

fds = kVIS_getCurrentFds(hObject);

if ~isstruct(fds)
    errordlg('Nothing loaded...')
    return
end

% Get the track co-ords
[lat, lon, alt, t] = BSP_mapCoordsFcn(fds);

xlim = kVIS_getDataRange(hObject, 'XLim');
locs = find(t>xlim(1) & t<xlim(2));

lon = kVIS_downSample(lon(locs), 5);
lat = kVIS_downSample(lat(locs), 5);
alt = kVIS_downSample(alt(locs), 5);

% track colouring
try
    [c, signalMeta] = kVIS_fdsGetCurrentChannel(hObject);
    
    chan_name = [signalMeta.name ' ' signalMeta.unit];
    
    c = kVIS_downSample(c(locs), 5);
catch
    c = zeros(size(lon));
    chan_name = [];
end

%
% create plot
%
axes_handle = handles.uiTabDataViewer.axesBot;
cla(axes_handle, 'reset');
hold on

h = scatter3(axes_handle, lon, lat, alt, 4, c);
h.Tag = 'MapPlot';


if (xlim(1)-0.2 <= min(t))
    % Plot take off marker
    plot(axes_handle, lon(1),lat(1),'wo','lineWidth',2,'markerSize',10);
else
    % Plot in marker
    text(axes_handle, lon(1),lat(1),'IN','color','w','HorizontalAlignment','center','FontWeight','bold');
end

if (xlim(2)+0.2 >= max(t))
    % Plot land marker
    plot(axes_handle, lon(end),lat(end),'wx','lineWidth',2,'markerSize',10);
else
    % Plot out marker
    text(axes_handle, lon(end),lat(end),'OUT','color','w','HorizontalAlignment','center','FontWeight','bold');
end


% % Fix up the axes
% dxlims = (max(lon)-min(lon))*0.1; dxlim = max(abs(dxlims));
% dylims = (max(lat)-min(lat))*0.1; dylim = max(abs(dylims));
% xlim([min(lon) max(lon)]+dxlim*[-1 1]);  ylim([min(lat) max(lat)]+dylim*[-1 1]);

% Add google map underlay
plot_google_map( ...
    'mapType','satellite', ...
    'MapScale',2, ...
    'Refresh',1, ...
    'Axis', axes_handle,...
    'apikey', handles.preferences.google_maps_api_key...
    );

% pretty run
title(['Track color: ' chan_name], 'Color','w', 'FontSize', 18)

axes_handle.XColor = 'w';
axes_handle.YColor = 'w';
axes_handle.ZColor = 'w';

view(axes_handle, 2)

colormap jet
cb = colorbar;
cb.Color = 'w';
return
