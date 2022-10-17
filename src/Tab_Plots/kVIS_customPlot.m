%
%> @file kVIS_customPlot.m
%> @brief Generate custom plot from XLS definition in the given axes
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
%> @brief Generate custom plot from XLS definition in the given axes
%>
%> @param Target axes
%> @param FDS file
%> @param Plot definition structure
%> @param Plot definition row number
%> @param Plot time axis limits 
%> @param Plot style structure
%
%> @return Axes handles
%> @return Error flag
%
function [ax, error] = kVIS_customPlot(ax, fds, plotDef, plotDefRowNo, lims, Style, idxFdsCurrent)

error = 0;

% plot definition columns:
plotNo = 1;
Row = 2;
Col = 3;
AxesLayout = 4;
xAxisLabel = 5;
yAxisLabel = 6;
LegendStyle= 7;
LegendLocation = 8;
xChannel = 10;
yChannel = 11;
cChannel = 12;
PlotStyle = 13;
Color = 14;
ScaleFactor = 15;
fcnHandle = 16;
fcnChannel = 17;
LabelOverride = 18;
UnitOverride = 19;
AxesFormatting = 20;

% line coloring provided by custom plot fcn
plotFcnColors=[];

%% X,Y-axis data / label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get y data
[yp, yMeta, fdsIndex] = kVIS_cpltGetChannel(fds, plotDef, plotDefRowNo, yChannel, idxFdsCurrent);

if yp == -1
    disp('y channel not found... Skipping.')
    error = 1;
    return
end

% get x vector (default: time)
if ~isnan(plotDef{plotDefRowNo,xChannel})

    [xp, xMeta] = kVIS_cpltGetChannel(fds, plotDef, plotDefRowNo, xChannel, idxFdsCurrent);

    if xp == -1
        disp('x channel not found... Skipping.')
        error = 1;
        return
    end
else
    xp = yMeta.timeVec;
    xMeta.name = 'Time_UNIT_sec';
end


% constrain to xlim
pts = find(yMeta.timeVec > lims(1) & yMeta.timeVec < lims(2));
xp = xp(pts);
yp = yp(pts);

%% Y-axis data proc / label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% apply scale factor
yp = yp * plotDef{plotDefRowNo,ScaleFactor};

% apply function to data - fcnData content is given to function as
% string to be processed inside fcn.
if ~isnan(plotDef{plotDefRowNo,fcnHandle})

    try
        [yp, xp2, plotFcnColors] = feval(plotDef{plotDefRowNo,fcnHandle}, yp, fds{fdsIndex}, pts, plotDef{plotDefRowNo,fcnChannel});
        if ~isempty(xp2)
            xp = xp2;
            xMeta.texName = 'frequency \; [Hz]';
        end
    catch ME
        ME.identifier
        disp('Function eval error... Ignoring.')
        error = 1;
        return
    end
else
    xp2 = [];
end

% LabelOverride
if ~isnan(plotDef{plotDefRowNo, LabelOverride})
    yLbl = kVIS_generateLabels(plotDef{plotDefRowNo, LabelOverride}, []);
else
    yLbl = kVIS_generateLabels(yMeta, []);
end

% UnitOverride
if ~isnan(plotDef{plotDefRowNo, UnitOverride})

    if ~isnan(plotDef{plotDefRowNo, LabelOverride})
        % Combine label and unit override
        str = [plotDef{plotDefRowNo, LabelOverride} '  [' plotDef{plotDefRowNo, UnitOverride} ']'];
        yLbl = kVIS_generateLabels(str, []);
    else
        % Combine original label and unit override latex string - might break....
        str = split(yLbl,' $');
        yLbl = [str{1} ' $ [' kVIS_generateLabels(plotDef{plotDefRowNo, UnitOverride}, []) ']'];
    end
end

% ensure data is not complex
if ~isreal(yp)
    disp('complex magic :( converting to real...')
    yp = real(yp);
end

% line styles
if ~isnan(plotDef{plotDefRowNo,PlotStyle})
    lineStyle = plotDef{plotDefRowNo,PlotStyle};
else
    lineStyle = [];
end

if ~isnan(plotDef{plotDefRowNo,Color})
    lineColor = plotDef{plotDefRowNo,Color};
else
    lineColor = [];
end

% legend overrides
if ~isnan(plotDef{plotDefRowNo,LegendLocation})
    Style.Legend.Location = plotDef{plotDefRowNo,LegendLocation};
end

if ~isnan(plotDef{plotDefRowNo,LegendStyle})
    Style.Legend.Orientation = plotDef{plotDefRowNo,LegendStyle};
end

%% plot data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% axes style
if plotDef{plotDefRowNo,AxesLayout} == 'L'
    yyaxis(ax, 'left')
elseif plotDef{plotDefRowNo,AxesLayout} == 'R'
    yyaxis(ax, 'right')
else
    % single plot
end

% scatter plot
if ~isnan(plotDef{plotDefRowNo,cChannel})

    [col, ~] = kVIS_cpltGetChannel(fds, plotDef, plotDefRowNo, cChannel, idxFdsCurrent);

    if col == -1
        disp('Colour channel not available...')
        col = ones(size(xp));
    end

    p = scatter(ax, xp, yp, 2, col(pts));
    axis(ax, 'tight');

elseif ~isempty(plotFcnColors)

    p = scatter(ax, xp, yp, 2, plotFcnColors);
    map = [0.2 0.8 0.2; 0.8 0 0];
    colormap(ax,map);
    axis(ax, 'tight');

else

    %
    % plot the signal into the specified axes
    %
    xLbl    = kVIS_generateLabels(xMeta, []);
    
    xLimits = [lims(1) lims(2)];
    yLimits = [NaN NaN];
    interactiveToggle = true;

    kVIS_plotSignal2(ax, @plot, ...
        xp, xMeta, ...
        yp, yMeta, ...
        lineColor, lineStyle, ...
        xLbl, yLbl, ...
        xLimits, yLimits, ...
        true, ...
        Style, ...
        interactiveToggle ...
        );

end


%% annotations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isnan(plotDef{plotDefRowNo, xAxisLabel})
    % generate (or ignore) custom x axis label
    if ~strcmp(plotDef{plotDefRowNo, xAxisLabel},'none')
        xlabel(kVIS_generateLabels(plotDef{plotDefRowNo, xAxisLabel}, []),'Interpreter','latex','FontSize',13)
    end
end

if ~isnan(plotDef{plotDefRowNo, yAxisLabel})
    ylabel(kVIS_generateLabels(plotDef{plotDefRowNo, yAxisLabel}, []),'Interpreter','latex', 'FontSize', 13);
end

if ~isnan(plotDef{plotDefRowNo,AxesFormatting})
    % read semicolon delimited string of axes formatting commands
    str = strsplit(plotDef{plotDefRowNo,AxesFormatting},';');
    % apply commands
    for J = 1:size(str,2)
        eval(str{J});
    end
end

%     kVIS_setGraphicsStyle(ax(pltindex), Style.Axes);

% non time x vector - don't link
if any(~isnan(plotDef{plotDefRowNo,xChannel})) || ~isempty(xp2)
    ax.Tag = 'noXaxislink';
else
    ax.Tag = 'Xaxislink';
end

end

%%
% Get channel data from selected FDS
%
function [yp, yMeta, fdsIndex] = kVIS_cpltGetChannel(fds, plotDef, plotDefRowNo, colNo, idxFdsCurrent)
%
% Source fds - identifier gives list entry number
%
yChanFDS = strsplit(plotDef{plotDefRowNo, colNo}, ':');

if length(yChanFDS) > 1
    % get data from specified fds
    yChanID = strsplit(yChanFDS{2}, '/');
    fdsIndex = str2double(yChanFDS{1});
    [yp, yMeta] = kVIS_fdsGetChannel(fds{fdsIndex}, yChanID{1}, yChanID{2});
else
    % get data from currently selected fds
    yChanID = strsplit(yChanFDS{1}, '/');
    fdsIndex = idxFdsCurrent;
    [yp, yMeta] = kVIS_fdsGetChannel(fds{fdsIndex}, yChanID{1}, yChanID{2});
end
end