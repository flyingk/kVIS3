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

function kVIS_plotSignal2(axes_handle, plotFcn, ...
                          xData, xDataMeta, ...
                          signal, signalMeta, ...
                          lineColor, lineStyle, ...
                          xLbl, yLbl, ...
                          xLimits, yLimits, ...
                          hold_mode, ...
                          plotStyles, ...
                          interactive ...
                          )
%
% Add a signal to the supplied axes.
% The UserData field of every line is filled with metadata that allows to
% identify the data source.
% Additionally, a context menu is setup to provide editing features.
%
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')

%
% Hold mode
%
if hold_mode == true
    hold(axes_handle, 'on');
else
    hold(axes_handle, 'off');
end
%
% plot line (linear/log/others)
%
newLine = feval(plotFcn, axes_handle, xData, signal);

if ~isempty(lineColor)
    newLine.Color = lineColor;
end

if ~isempty(lineStyle)
    newLine.lineStyle = lineStyle;
end

%
% save meta data
%
newLine.DisplayName               = yLbl;

newLine.UserData                  = struct();
newLine.UserData.xDataMeta        = xDataMeta;
newLine.UserData.signalMeta       = signalMeta;

newLine.UserData.yMin             = min(signal);
newLine.UserData.yMax             = max(signal);

if interactive == true
    newLine.UIContextMenu = kVIS_createPlotLineContextMenu(newLine);
end

%% adjust axes limits to data range fields
current_lines = kVIS_findValidPlotLines(axes_handle);

% time axis
xlim(axes_handle, xLimits);

if any(isnan(yLimits))
    % vertical axis - add margins to top and bottom
    plotMin = min(arrayfun(@(x) x.UserData.yMin, current_lines));
    plotMax = max(arrayfun(@(x) x.UserData.yMax, current_lines));

    marginL = abs(0.05*plotMin);
    if marginL == 0
        marginL = 0.05;
    end

    marginU = abs(0.05*plotMax);
    if marginU == 0
        marginU = 0.05;
    end

    ylim(axes_handle, [plotMin-marginL plotMax+marginU]);
else
    % set to prescribed limits
    ylim(axes_handle, yLimits);
end

%% labels
xlabel(axes_handle, xLbl, 'Interpreter', 'latex')
    
if size(current_lines) == 1
    [ labelStr ] = current_lines.DisplayName;
    ylabel(axes_handle, labelStr, 'Interpreter', 'latex', 'FontSize', 13)
else
    ylabel(axes_handle, []);
    lg = legend(axes_handle, current_lines, {}, 'Interpreter', 'latex');
    lg.ItemHitFcn = @legendCallback;
    kVIS_setGraphicsStyle(lg, plotStyles.Legend);
end

% update all axes styles
kVIS_setGraphicsStyle(axes_handle, plotStyles.Axes);
end

function legendCallback(h, events)
%
% Toggle line visibility when clicking on corresponding legend item
%
if strcmp(events.Peer.Visible, 'on')
    events.Peer.Visible = 'off';
else
    events.Peer.Visible = 'on';
end
end