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

function kVIS_fftUpdate(~, ~)

targetPanel = findobj('Tag', 'fftPanel');
ax = findobj(targetPanel, 'Type', 'axes');

if ~isfield(ax.UserData, 'fmin')
    ax.UserData.fmin = 0.01;
    ax.UserData.fmax = 10;
end

sourcePanel = targetPanel.UserData.fftLink;

lines = findobj(sourcePanel, 'Type', 'Line');

% generate psd
if ~isempty(lines)
    
    % get selected range
    xRange = kVIS_getDataRange(gcf, 'XLim');
        
    % save axes style
    xScale = ax.XScale;
    yScale = ax.YScale;
    
    ll = size(lines,1);
    
    if ll > 1
        hold(ax, 'on');
    else
        hold(ax, 'off');
    end
    
    fmin = ax.UserData.fmin;
    fmax = ax.UserData.fmax;
    
    for i=1:ll
        % generate psd - needs to be done one by one to account for
        % potentially different sample rates...
        signal = lines(i).YData';
        timeVec= lines(i).XData';
        colour = lines(i).Color;
        
        % generate psd for selected range
        locs = find(timeVec >= xRange(1) & timeVec <= xRange(2));
        signal = signal(locs);
        timeVec= timeVec(locs);
        
        if any(isnan(signal))
            errordlg('Signal contains NaN. FFT not possible at the moment...')
            return
        end
        
        [p, f] = spect(signal-mean(signal), timeVec, [fmin:0.01:fmax]*2*pi, 10, 0, 0);
        
        plot(ax, f, p, 'Color', colour)
        
    end
    
    grid(ax, 'on');
    
    ax.UIContextMenu = kVIS_createFFTContextMenu(ax);
    ax.XScale = xScale;
    ax.YScale = yScale;
    
    xlabel(ax, 'Frequency [Hz]');
    ylabel(ax, 'Power Spectral Density (PSD)');
    
    handles = guidata(gcf);
    kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.AxesB);
    kVIS_axesResizeToContainer(ax);
end


end

function [ m ] = kVIS_createFFTContextMenu(ax)
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
    'Label', 'linear', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'log x', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'log y', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'loglog', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Set Frequency Range', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );

end