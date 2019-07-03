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

function kVIS_correlationPlot(~, ~)

% active time panel
sourcePanel = kVIS_dataViewerGetActivePanel();
% link target
targetPanel = sourcePanel.linkTo;

if isempty(targetPanel)
    errordlg('Cannot find data source. Ensure the corresponding timeplot is selected for manual update...')
    return
end

% plot axes
ax = targetPanel.axesHandle;

lines = findobj(sourcePanel, 'Type', 'Line');

ll = size(lines,1);

% generate correlation plot
if ll >= 2
    
    % clear plot
    cla(ax);
    
    % get selected range
    xRange = kVIS_getDataRange(gcf, 'XLim');
        
%     % save axes style (lin/log)
%     xScale = ax.XScale;
%     yScale = ax.YScale;

    if ll > 2
        hold(ax, 'on');
    else
        hold(ax, 'off');
    end

    % base signal to compare
    signal0 = lines(ll).YData';
    timeVec0= lines(ll).XData';
    locs = find(timeVec0 >= xRange(1) & timeVec0 <= xRange(2));
    signal0 = signal0(locs);
    xlab = lines(ll).DisplayName;
    
    % last plotted line is first...
    for i = 1:ll-1
        % generate plot - needs to be done one by one to account for
        % potentially different sample rates...
        signal = lines(i).YData';
        timeVec= lines(i).XData';
        colour = lines(i).Color;
        
        % generate plot for selected range
        locs = find(timeVec >= xRange(1) & timeVec <= xRange(2));
        signal  = signal(locs);
        
        plot(ax, signal0, signal, 'Color', colour, 'Linestyle','none','Marker','+')
        
    end
    
    grid(ax, 'on');
    
    ax.UIContextMenu = kVIS_createCorrContextMenu(ax);
%     ax.XScale = xScale;
%     ax.YScale = yScale;
%     ax.YLim = targetPanel.fftYLim;
%     
    xlabel(ax, xlab);
%     ylabel(ax, 'Power Spectral Density (PSD)');
    
    handles = guidata(gcf);
    kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.AxesB);
    kVIS_axesResizeToContainer(ax);
end


end

function [ m ] = kVIS_createCorrContextMenu(ax)
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
    'Label', 'Force Update', ...
    'Callback', {@kVIS_corrContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Simple Fitting', ...
    'Callback', {@kVIS_corrContextMenuAction, ax} ...
    );

end