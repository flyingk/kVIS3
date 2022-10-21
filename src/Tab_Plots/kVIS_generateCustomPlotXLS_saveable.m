%
%> @file kVIS_generateCustomPlotXLS.m
%> @brief Generate custom plot window from XLS definition
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
function [ ax ] = kVIS_generateCustomPlotXLS_saveable(~,~, fds, plotName, lims, Style, fds_name, idxFdsCurrent, interactiveToggle)

warning('on','verbose')
% warning('off', 'MATLAB:gui:latexsup:UnableToInterpretLaTeXString')
% warning('off', 'MATLAB:gui:latexsup:UnsupportedFont')
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')

% Plot definition.
% Columns:
plotNo = 1;
Row = 2;
Col = 3;

figH = figure();

[~,~,plotDef] = xlsread(plotName,'','A:T','basic');

figH.Position = [100,100,plotDef{3,5},plotDef{3,6}];
figH.Name     = [fds_name{idxFdsCurrent} ': ' plotDef{3,2}];

% get data content
% remove header
plotDef = plotDef(6:end,:);
% remove extra lines from below the data
rl = ~isnan(cell2mat(plotDef(:,1)));
plotDef = plotDef(rl==1,:);


% set up figure
PlotRows = cell2mat(plotDef(:,Row));
PlotCols = cell2mat(plotDef(:,Col));

aaa=diff(PlotCols);
bbb=find(aaa>0);
nPlotRows=[PlotRows(bbb)' PlotRows(end)];

nPlots    = max(cell2mat(plotDef(:,plotNo)));
nPlotCols = max(PlotCols);

hh = setupPanels(figH, nPlotRows, nPlotCols);

oldpltindex = 0;

for plotDefRowNo = 1:size(plotDef, 1)
    %% plot setup
    pltindex = plotDef{plotDefRowNo,plotNo};

    if pltindex ~= oldpltindex
        % next plot axes
        currentPlotLineNo = 1;

        hh(pltindex).BackgroundColor = getpref('kVIS_prefs','uiBackgroundColour');
        hh(pltindex).Tag = 'cpTimeplot';

        ax(pltindex) = axes(hh(pltindex), 'Units', 'normalized');
        grid(ax(pltindex), 'on');
        kVIS_axesResizeToContainer(ax(pltindex));
    else
        % continue in current axes
        currentPlotLineNo = currentPlotLineNo + 1;
    end

    oldpltindex = pltindex;

    [ax(pltindex), error] = kVIS_customPlot(ax(pltindex), fds, plotDef, plotDefRowNo, lims, Style, idxFdsCurrent, interactiveToggle);

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

%
% UI panel set up
%
function pnl = setupPanels(f, rows, cols)

% panel width
colW = 1./cols;

% panel height
rowH = 1./rows;

K = 1;

for I = 1:cols

    % x-coord of column
    colX = 0:1/cols:0.999999999;

    for J = rows(I):-1:1 % start from the top

        % y-coord of panel
        rowY = [0:1/rows(I):0.9999999];

        pnl(K) = uipanel('Parent',f,...
            'Position',[colX(I) rowY(J) colW rowH(I)]);

        K = K + 1;

    end

end
end