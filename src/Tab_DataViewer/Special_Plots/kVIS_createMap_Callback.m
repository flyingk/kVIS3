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

function varargout = kVIS_createMap_Callback(hObject, ~, pathColorChannel)
% Function for plotting the flight path using plot_google_map
%
% matt & kai

fds = kVIS_getCurrentFds(hObject);

if ~isstruct(fds)
    errordlg('Nothing loaded...')
    return
end


if isempty(getpref('kVIS_prefs','google_maps_api_key'))
    kVIS_terminalMsg('Enter Google Maps Static API key in preferences for satellite plot. Fallback to Open street map');
    osm = true;
else
    kVIS_terminalMsg('Generating satellite map plot...');
    osm = false;
end

% Get the track co-ords - assumed on a common time vector
try
    [lat, lon, alt, t] = BSP_mapCoordsFcn(fds);
catch
    errordlg('Map coordinate BSP function not found or function error.')
%     keyboard
    return;
end

% get selected time limits
xlim = kVIS_getDataRange(hObject, 'XLim');
% find corresponding samples
locs = find(t>xlim(1) & t<xlim(2));

% create time vector for map plot @ 25 Hz
tNew = t(locs(1)):1/25:t(locs(end));

lon = kVIS_reSample(lon, t, tNew, false);
lat = kVIS_reSample(lat, t, tNew, false);
alt = kVIS_reSample(alt, t, tNew, false);

% track colouring
try
    if isempty(pathColorChannel)
        % use currently selected channel
        [c, signalMeta] = kVIS_GetCurrentChannel(hObject);
    else
        % use specified channel
        pcc = strsplit(pathColorChannel,'/');
        [c, signalMeta] = kVIS_fdsGetChannel(fds, pcc{1}, pcc{2});
    end
    
    chan_name = [signalMeta.name ' [' signalMeta.unit ']'];
    
    c = kVIS_reSample(c, t, tNew);
catch
    c = zeros(size(lon));
    chan_name = [];
end


%
% create plot
%
if nargout == 0
    targetPanel = kVIS_dataViewerGetActivePanel();
    axes_handle = targetPanel.axesHandle;
else
    figHdl = figure('Color','w','Visible','off');
    axes_handle = axes(figHdl);
end

cla(axes_handle, 'reset');
hold on

h = scatter3(axes_handle, lon, lat, alt, 4, c);
h.Tag = 'MapPlot';
h.UserData.timeVec = tNew;


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

if osm == true
    % Use OpenStreetMap which not requires a Google API key
    % Add OpenStreetMap underlay
    plot_openstreetmap('Alpha', 1, 'Scale', 1, 'Alt', min(alt));
else
    % Add google map underlay
    plot_google_map( ...
        'mapType','satellite', ...
        'MapScale',2, ...
        'Refresh',1, ...
        'Axis', axes_handle,...
        'apikey', getpref('kVIS_prefs','google_maps_api_key'),...
        'Alt', min(alt)...
        );
end

% Pretty run
zlim([min(alt), max(alt)]);
lbl = kVIS_generateLabels(signalMeta, []);

view(axes_handle, 2)

colormap(axes_handle, 'jet')
cb = colorbar(axes_handle,'Location','west');
cb.Color = 'w';

if nargout == 0
    
    title(h.Parent,['Track color: ' lbl], 'Color','w', 'FontSize', 14, 'Interpreter', 'latex')
    axes_handle.XColor = 'w';
    axes_handle.YColor = 'w';
    axes_handle.ZColor = 'w';
    kVIS_axesResizeToContainer(axes_handle);
    axes_handle.UIContextMenu = kVIS_createMapContextMenu(axes_handle);
else
    
    title(h.Parent,['Track color: ' lbl], 'Color','k', 'FontSize', 14, 'Interpreter', 'latex')
    figHdl.Name = 'Flight Track';
    varargout{1} = figHdl;
end
end

function [ m ] = kVIS_createMapContextMenu(ax)
% This function creates a context menu for a given Line object.
% The menu displays some metadata helping to identify the line, and
% provides some callback actions.

m = uicontextmenu();

% metadata section
%     uimenu('Parent', m, 'Label', sprintf('Type: %s', panel.UserData.PlotType), 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Units: %s' , strip(line.UserData.signalMeta.unit))       , 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Data Set: %s', strip(line.UserData.signalMeta.dataSet)), 'Enable', 'off');
%     if isstruct(line.UserData) && isfield(line.UserData, 'yyaxis')
%         uimenu('Parent', m, 'Label', sprintf('Y Axis: %s', line.UserData.yyaxis), 'Enable', 'off');
%     end

uimenu( ...
    'Parent', m, ...
    'Label', 'Refresh Map', ...
    'Checked', 'off', ...
    'Callback', @kVIS_mapContextMenuAction ...
    );

uimenu( ...
    'Parent', m, ...
    'Label', 'Show BSP data', ...
    'Checked', 'off', ...
    'Callback', @kVIS_mapContextMenuAction ...
    );

end