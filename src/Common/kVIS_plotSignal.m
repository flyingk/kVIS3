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

function kVIS_plotSignal(hObject, signal, signalMeta, hold_mode, axes_handle, plotFcn)
% Add a signal to the DataViewer plot.
% The UserData field of every line is filled with metadata that allows to
% identify the data source.
% Additionally, a context menu is setup to provide editing features.

handles=guidata(hObject);

% current_lines = kVIS_findValidPlotLines(axes_handle);

% if ~isempty(current_lines)
%     
%     plot_idx = ...
%         arrayfun(@(x) x.UserData.flight_idx , current_lines) == flight_idx  & ...
%         arrayfun(@(x) x.UserData.var_idx    , current_lines) == var_idx     & ...
%         arrayfun(@(x) x.UserData.channel_idx, current_lines) == channel_idx;
%     plot_exists = any(plot_idx);
%     
%     if plot_exists
%         delete(current_lines(plot_idx));
%         return;
%     end
%     
% end

%
% Hold mode
%
if hold_mode == 1
    hold(axes_handle, 'on');
else
    hold(axes_handle, 'off');
end
%
% plot line (linear/log/others)
%
newLine = feval(plotFcn, axes_handle, signalMeta.timeVec, signal);
%
% save meta data
%
newLine.DisplayName               = signalMeta.texName;

newLine.UserData                  = struct();
newLine.UserData.signalMeta       = signalMeta;

newLine.UserData.yMin             = min(signal);
newLine.UserData.yMax             = max(signal);

% newLine.UserData.current_offset   = current_offset;

newLine.UIContextMenu = kVIS_createPlotLineContextMenu(newLine);

%% adjust axes limits to data range fields

% time axis
kVIS_dataRangeUpdate_Callback(hObject, [], 'XLim');

% vertical axis - add margins to top and bottom
current_lines = kVIS_findValidPlotLines(axes_handle);

plotMin = min(arrayfun(@(x) x.UserData.yMin, current_lines));
plotMax = max(arrayfun(@(x) x.UserData.yMax, current_lines));

marginL = abs(0.1*plotMin);
if marginL == 0
    marginL = 0.1;
end

marginU = abs(0.1*plotMax);
if marginU == 0
    marginU = 0.1;
end

if axes_handle == handles.uiTabDataViewer.axesBot
    kVIS_setDataRange(hObject, 'YlLim', [plotMin-marginL plotMax+marginU]);
    kVIS_dataRangeUpdate_Callback(hObject, [], 'YlLim');
elseif axes_handle == handles.uiTabDataViewer.axesTop
    kVIS_setDataRange(hObject, 'YtLim', [plotMin-marginL plotMax+marginU]);
    kVIS_dataRangeUpdate_Callback(hObject, [], 'YtLim');
end


%% labels
if axes_handle == handles.uiTabDataViewer.axesBot
    xlabel(axes_handle,'Time [sec]');
    
    if size(current_lines) == 1
        lbl = [signalMeta.dispName ' (' signalMeta.unit ') (' signalMeta.frame ')'];
        ylabel(axes_handle, lbl, 'Interpreter','none');
%         lbl = ['$ \mathsf{' signalMeta.texName(2:end-1) '} $']
%         ylabel(axes_handle, lbl, 'Interpreter','latex', 'FontSize', 16);
    else
        ylabel(axes_handle, []);
        lg = legend(current_lines, {},'Interpreter','latex');
        kVIS_setGraphicsStyle(lg, handles.uiTabDataViewer.plotStyles.Legend);
    end
end

% update all axes styles
kVIS_setGraphicsStyle(handles.uiTabDataViewer.axesTop, handles.uiTabDataViewer.plotStyles.AxesT);
kVIS_setGraphicsStyle(handles.uiTabDataViewer.axesBot, handles.uiTabDataViewer.plotStyles.AxesB);
handles.uiTabDataViewer.axesBot.XRuler.Exponent = 0; % no exp in time stamps
% xtickformat(handles.uiTabDataViewer.axesBot, '%10.2f')
end