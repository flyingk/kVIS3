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

% ensure data is not complex
if ~isreal(yp)
    disp('complex magic :( converting to real...')
    yp = real(yp);
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
    yLbl    = kVIS_generateLabels(yMeta, []);
    xLimits = [lims(1) lims(2)];
    yLimits = [NaN NaN];
    interactiveToggle = true;

    kVIS_plotSignal2(ax, @plot, ...
        xp, xMeta, ...
        yp, yMeta, ...
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
else
    ylabel([])
end

%     % LabelOverride
%     if ~isnan(plotDef{plotDefRowNo, LabelOverride})
%         yLabel = kVIS_generateLabels(plotDef{plotDefRowNo, LabelOverride}, []);
%     end
%
%
%     % UnitOverride
%     if ~isnan(plotDef{plotDefRowNo, UnitOverride})
%
%         if ~isnan(plotDef{plotDefRowNo, LabelOverride})
%             % Combine label and unit override
%             str = [plotDef{plotDefRowNo, LabelOverride} '  [' plotDef{plotDefRowNo, UnitOverride} ']'];
%             yLabel = kVIS_generateLabels(str, []);
%         else
%             % Combine original label and unit override latex string - might break....
%             str = split(yLabel,' $');
%             yLabel = [str{1} ' $ [' kVIS_generateLabels(plotDef{plotDefRowNo, UnitOverride}, []) ']'];
%         end
%     end

%
%         if ~isnan(plotDef{plotDefRowNo,LegendLocation})
%             Style.Legend.Location = plotDef{plotDefRowNo,LegendLocation};
%         end
%
%         if ~isnan(plotDef{plotDefRowNo,LegendStyle})
%             Style.Legend.Orientation = plotDef{plotDefRowNo,LegendStyle};
%         end
%

%     end

%     %% formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     if ~isnan(plotDef{plotDefRowNo,PlotStyle})
%         p.LineStyle = plotDef{plotDefRowNo,PlotStyle};
%     end
%
%     if ~isnan(plotDef{plotDefRowNo,Color})
%         p.Color = plotDef{plotDefRowNo,Color};
%     end
%
%
%
%     if ~isnan(plotDef{plotDefRowNo,AxesFormatting})
%         % read semicolon delimited string of axes formatting commands
%         str = strsplit(plotDef{plotDefRowNo,AxesFormatting},';');
%         % apply commands
%         for J = 1:size(str,2)
%             eval(str{J});
%         end
%     end
%
% %     ax(pltindex).YLim(1) = ax(pltindex).YLim(1) * 0.98;
%     if ax(pltindex).YLim(1) == 0
%         ax(pltindex).YLim(1) = -0.1;
%     end
% %     ax(pltindex).YLim(2) = ax(pltindex).YLim(2) * 1.02;
%     if ax(pltindex).YLim(2) == 0
%         ax(pltindex).YLim(2) = 0.1;
%     end
%
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