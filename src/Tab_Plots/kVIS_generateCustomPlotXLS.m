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
function [ ] = kVIS_generateCustomPlotXLS(figure_handle, fds, plotDef, lims, Style)

warning('on','verbose')
% warning('off', 'MATLAB:gui:latexsup:UnableToInterpretLaTeXString')
% warning('off', 'MATLAB:gui:latexsup:UnsupportedFont')
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')

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
%
% format figure
%
kVIS_setGraphicsStyle(figure_handle, Style.Figure);

main_div = uix.VBox('Parent', figure_handle, 'Tag', 'vbox');

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
    'Callback', @kVIS_reportModeFigFormat_Callback ...
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

% Check plot definition.
% Columns:
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

% line coloring provided by custom plot fcn
plotFcnColors=[];

for plotDefRowNo = 1:size(plotDef, 1)
    %% plot setup
    pltindex = plotDef{plotDefRowNo,plotNo};
    
    if pltindex ~= oldpltindex
        % next plot axes
        currentPlotLineNo = 1;
        clear p labelstr mm ma
        
        hh(pltindex) = uipanel('Parent', columnIDX(plotDef{plotDefRowNo,Col}), 'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'));
        hh(pltindex).Tag = 'cpTimeplot';
        
        ax(pltindex) = axes(hh(pltindex), 'Units', 'normalized');
        hh(pltindex).SizeChangedFcn = @kVIS_panelSizeChanged_Callback;
    else
        % continue in current axes
        currentPlotLineNo = currentPlotLineNo + 1;
    end
    
    oldpltindex = pltindex;
    
    %% X,Y-axis data / label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get y data
    yChanID = strsplit(plotDef{plotDefRowNo, yChannel}, '/');
    [yp, yMeta] = kVIS_fdsGetChannel(fds, yChanID{1}, yChanID{2});
    
    if yp == -1
        disp('y channel not found... Skipping.')
        currentPlotLineNo = currentPlotLineNo - 1;
        continue;
    end
    
    % get x vector (default: time)
    if ~isnan(plotDef{plotDefRowNo,xChannel})
        xChanID = strsplit(plotDef{plotDefRowNo, xChannel}, '/');
        [xp, xMeta] = kVIS_fdsGetChannel(fds, xChanID{1}, xChanID{2});
        
        if xp == -1
            disp('x channel not found... Skipping.')
            currentPlotLineNo = currentPlotLineNo - 1;
            continue;
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
            [yp, xp2, plotFcnColors] = feval(plotDef{plotDefRowNo,fcnHandle}, yp, fds, pts, plotDef{plotDefRowNo,fcnChannel});
            if ~isempty(xp2)
                xp = xp2;
                xMeta.texName = 'frequency \; [Hz]';
            end
        catch ME
            ME.identifier
            disp('Function eval error... Ignoring.')
            currentPlotLineNo=currentPlotLineNo-1;
            continue;
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
        yyaxis(ax(pltindex), 'left')
    elseif plotDef{plotDefRowNo,AxesLayout} == 'R'
        yyaxis(ax(pltindex), 'right')
    else
        % single plot
    end

    % scatter plot
    if ~isnan(plotDef{plotDefRowNo,cChannel})
        
        ccC = strsplit(plotDef{plotDefRowNo, cChannel}, '/');
        
        [col] = kVIS_fdsGetChannel(fds, ccC{1}, ccC{2});
        
        if col == -1
            disp('Colour channel not available...')
            col = ones(size(xp));
        end
        
        p = scatter(ax(pltindex), xp, yp, 2, col(pts));
        axis(ax(pltindex), 'tight');
        
    elseif ~isempty(plotFcnColors)
        
        p = scatter(ax(pltindex), xp, yp, 2, plotFcnColors);
        map = [0.2 0.8 0.2; 0.8 0 0];
        colormap(ax(pltindex),map);
        axis(ax(pltindex), 'tight');
        
    else
        
        p = plot(ax(pltindex), xp, yp); 
        
        hold(ax(pltindex), 'on');
        axis(ax(pltindex), 'tight');
        
        p.LineWidth = 2.0;

    end
    
    
    %% annotations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isnan(plotDef{plotDefRowNo, xAxisLabel})
        % generate (or ignore) custom x axis label
        if ~strcmp(plotDef{plotDefRowNo, xAxisLabel},'none')
            xlabel(kVIS_generateLabels(plotDef{plotDefRowNo, xAxisLabel}, []),'Interpreter','latex','FontSize',13)
        end
    else
        xlabel(kVIS_generateLabels(xMeta, []),'Interpreter','latex','FontSize',13)
    end
    
    % LabelOverride
    if ~isnan(plotDef{plotDefRowNo, LabelOverride})
        yLabel = kVIS_generateLabels(plotDef{plotDefRowNo, LabelOverride}, []);
    else
        yLabel = kVIS_generateLabels(yMeta, []);
    end

    % UnitOverride
    if ~isnan(plotDef{plotDefRowNo, UnitOverride})
        
        if ~isnan(plotDef{plotDefRowNo, LabelOverride})
            % Combine label and unit override
            str = [plotDef{plotDefRowNo, LabelOverride} '  [' plotDef{plotDefRowNo, UnitOverride} ']'];
            yLabel = kVIS_generateLabels(str, []);
        else
            % Combine original label and unit override latex string - might break....
            str = split(yLabel,' $');
            yLabel = [str{1} ' $ [' kVIS_generateLabels(plotDef{plotDefRowNo, UnitOverride}, []) ']'];
        end
    end
    
    % collect labels for legend/ylabel
    labelstr{currentPlotLineNo} = yLabel; %#ok<AGROW>
   
    if currentPlotLineNo == 1 % this doesn't work with yyaxis...
        ylabel(labelstr{currentPlotLineNo},'Interpreter','latex', 'FontSize', 13);
    else
        
        if ~isnan(plotDef{plotDefRowNo, yAxisLabel})
            ylabel(kVIS_generateLabels(plotDef{plotDefRowNo, yAxisLabel}, []),'Interpreter','latex', 'FontSize', 13);
        else
            ylabel([])
        end
        
        
        legend_handle = legend(ax(pltindex), labelstr);
        
        if ~isnan(plotDef{plotDefRowNo,LegendLocation})
            Style.Legend.Location = plotDef{plotDefRowNo,LegendLocation};
        end
        
        if ~isnan(plotDef{plotDefRowNo,LegendStyle})
            Style.Legend.Orientation = plotDef{plotDefRowNo,LegendStyle};
        end
        
        kVIS_setGraphicsStyle(legend_handle, Style.Legend);
    end
    
    %% formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~isnan(plotDef{plotDefRowNo,PlotStyle})
        p.LineStyle = plotDef{plotDefRowNo,PlotStyle};
    end
    
    if ~isnan(plotDef{plotDefRowNo,Color})
        p.Color = plotDef{plotDefRowNo,Color};
    end
    
    grid(ax(pltindex), 'on');
    
    if ~isnan(plotDef{plotDefRowNo,AxesFormatting}) && ischar(plotDef{plotDefRowNo,AxesFormatting})
        % read semicolon delimited string of axes formatting commands
        str = strsplit(plotDef{plotDefRowNo,AxesFormatting},';');
        % apply commands
        for J = 1:size(str,2)
            eval(str{J});
        end
    end
    
    % specific x vector - don't link
    if any(~isnan(plotDef{plotDefRowNo,xChannel})) || ~isempty(xp2)
        Style.Axes.Tag = 'noXaxislink';
    else
        Style.Axes.Tag = 'Xaxislink';
        xlim([p.XData(1) p.XData(end)])
    end
    
%     ax(pltindex).YLim(1) = ax(pltindex).YLim(1) * 0.98;
    if ax(pltindex).YLim(1) == 0
        ax(pltindex).YLim(1) = -0.1;
    end
%     ax(pltindex).YLim(2) = ax(pltindex).YLim(2) * 1.02;
    if ax(pltindex).YLim(2) == 0
        ax(pltindex).YLim(2) = 0.1;
    end
    
    kVIS_setGraphicsStyle(ax(pltindex), Style.Axes);
    
end
%
% maximise plot size - work required for yy plot
%
for currentPlotLineNo = 1:pltindex
    
    ax(currentPlotLineNo).XRuler.Exponent = 0; % no exponent in time stamps
    
end

% find all axes handle of type 'axes' and tag for linking
all_ha = findobj( figure_handle, 'type', 'axes', 'Tag', 'Xaxislink' );

if ~isempty(all_ha)
    linkaxes( all_ha, 'x' );
end

end