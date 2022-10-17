%
%> @file kVIS_generateCustomPlotXLS.m
%> @brief Generate custom plot from XLS definition
%
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

%
%> @brief Generate custom plot from XLS definition
%>
%> @param Target figure
%> @param FDS file
%> @param Plot definition structure
%> @param Plot time axis limits 
%> @param Plot style structure
%
%> @return Axes handles
%
function [ ax ] = kVIS_generateCustomPlotXLS(figH, fds, plotName, lims, Style, fds_name, idxFdsCurrent)

warning('on','verbose')
% warning('off', 'MATLAB:gui:latexsup:UnableToInterpretLaTeXString')
% warning('off', 'MATLAB:gui:latexsup:UnsupportedFont')
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')


[~,~,plotDef] = xlsread(plotName,'','A:T','basic');

figH.Position = [100,100,plotDef{3,5},plotDef{3,6}];
figH.Name     = [fds_name{idxFdsCurrent} ': ' plotDef{3,2}];

%
% format figure
%
DefaultStyle = struct();
DefaultStyle.Figure = struct();
DefaultStyle.Figure.Color = getpref('kVIS_prefs','uiBackgroundColour');

DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'w';
DefaultStyle.Axes.YColor = 'w';
DefaultStyle.Axes.GridColor = 'k';
DefaultStyle.Axes.MinorGridColor = 'k';

DefaultStyle.Legend.FontSize = 10;
DefaultStyle.Legend.Location = 'best';
DefaultStyle.Legend.Orientation = 'horizontal';
DefaultStyle.Legend.Interpreter = 'latex';

if isempty(Style)
    Style = DefaultStyle;
else
%     Style = KSID.Util.MergeStructs(Style, DefaultStyle);
end

kVIS_setGraphicsStyle(figH, Style.Figure);

%
% Build plot
%
main_div = uix.VBox('Parent', figH, 'Tag', 'vbox');

plts = uix.HBox('Parent', main_div);
plts.Tag = 'plts';

ctrls= uix.HButtonBox('Parent', main_div, ...
    'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'), ...
    'Spacing', 50, ...
    'HorizontalAlignment', 'right',...
    'Tag','btnBox');

main_div.Heights = [-1 40];

% Create buttons
uicontrol( ...
    ctrls, ...
    'Style', 'togglebutton', ...
    'String', 'Show Events', ...
    'Callback', @kVIS_CustomPlotShowEvents_Callback ...
);

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Export .fig', ...
    'Callback', {@kVIS_reportModeFigFormat_Callback,figH, fds, plotName, lims, Style, fds_name, idxFdsCurrent} ...
);

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Export .jpg', ...
    'Callback', @kVIS_reportMode_Callback ...
);

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Hide legends', ...
    'Callback', @kVIS_hide_all_legends_Callback ...
);

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Close', ...
    'Callback', @(src, event) close(gcbf()) ...
);

ctrls.ButtonSize = [100 30];

% Plot definition.
% Columns:
plotNo = 1;
Row = 2;
Col = 3;

% get data content
% remove header
plotDef = plotDef(6:end,:);
% remove extra lines from below the data
rl = ~isnan(cell2mat(plotDef(:,1)));
plotDef = plotDef(rl==1,:);

% set up figure
nPlots = max(cell2mat(plotDef(:,plotNo)));
nPlotRows = max(cell2mat(plotDef(:,Row)));
nPlotCols = max(cell2mat(plotDef(:,Col)));

for currentPlotLineNo = 1:nPlotCols
    columnIDX(currentPlotLineNo) = uix.VBox('Parent', plts);
end

oldpltindex = 0;

clc

for plotDefRowNo = 1:size(plotDef, 1)
    %% plot setup
    pltindex = plotDef{plotDefRowNo,plotNo};

    if pltindex ~= oldpltindex
        % next plot axes
        currentPlotLineNo = 1;

        hh(pltindex) = uipanel('Parent', columnIDX(plotDef{plotDefRowNo,Col}), 'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'));
        hh(pltindex).Tag = 'cpTimeplot';

        ax(pltindex) = axes(hh(pltindex), 'Units', 'normalized');
        grid(ax(pltindex), 'on');
        hh(pltindex).SizeChangedFcn = @kVIS_panelSizeChanged_Callback;
    else
        % continue in current axes
        currentPlotLineNo = currentPlotLineNo + 1;
    end

    oldpltindex = pltindex;

    [ax(pltindex), error] = kVIS_customPlot(ax(pltindex), fds, plotDef, plotDefRowNo, lims, Style, idxFdsCurrent);

    if error > 0
        currentPlotLineNo = currentPlotLineNo - 1;
        continue;
    end

    ax(pltindex).XRuler.Exponent = 0; % no exponent in time stamps

end

% find all axes handle of type 'axes' and tag for linking
all_ha = findobj( figH, 'type', 'axes', 'Tag', 'Xaxislink' );

if ~isempty(all_ha)
    linkaxes( all_ha, 'x' );
end

end