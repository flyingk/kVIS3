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

function [ fileNames ] = kVIS_generateReportPlotXLS(fds, plotDef, lims, Style, outFolder)

warning('on','verbose')
% warning('off', 'MATLAB:gui:latexsup:UnableToInterpretLaTeXString')
% warning('off', 'MATLAB:gui:latexsup:UnsupportedFont')
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode')

DefaultStyle = struct();
DefaultStyle.Figure = struct();
DefaultStyle.Figure.Color = getpref('kVIS_prefs','uiBackgroundColour');

DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'k';
DefaultStyle.Axes.YColor = 'k';
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

% kVIS_setGraphicsStyle(figure_handle, Style.Figure);

pltName = plotDef{3,2};


% Check plot definition.
% Columns:
plotNo = 1;
Row = 2;
Col = 3;
AxesLayout = 4;
xAxisLabel = 5;
yAxisLabel = 6;
LegendStyle= 7;
LegendLocation=8;
xChannel = 10;
yChannel = 11;
cChannel = 12;
PlotStyle = 13;
Color = 14;
ScaleFactor = 15;
fcnHandle = 16;
fcnChannel = 17;
LabelOverride =18;

% assert(iscell(plotDef) & size(plotDef, 2) == 19, 'Invalid plot definition');

% get data content
% remove header
plotDef = plotDef(6:end,1:19);
% remove extra lines from import
rl = ~isnan(cell2mat(plotDef(:,1)));
plotDef = plotDef(rl==1,1:19);


oldpltindex = 0;
hh=[];

% line coloring provided by custom plot fcn
plotFcnColors=[];

for i = 1:size(plotDef, 1)
    %% plot setup
    pltindex = plotDef{i,plotNo};
    
    if pltindex ~= oldpltindex
        
        if ~isempty(hh)
            delete(hh)
        end
        
        % next plot axes
        k=1;
        clear p labelstr mm ma
        
        hh = figure('Position',[0 0 750 375],'Color','w','Visible','off');
        hh.Tag = 'cpTimeplot';
        
        ax = axes(hh, 'Units', 'normalized');
        hh.SizeChangedFcn = @kVIS_panelSizeChanged_Callback;
    else
        % continue in current axes
        k=k+1;
    end
    
    oldpltindex = pltindex;
    
    %% X,Y-axis data / label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % get y data
    yChanID = strsplit(plotDef{i, yChannel}, '/');
    [yp, yMeta] = kVIS_fdsGetChannel(fds, yChanID{1}, yChanID{2});
    
    if yp == -1
        disp('y channel not found... Skipping.')
        k=k-1;
        continue;
    end
    
    % get x vector (default: time)
    if ~isnan(plotDef{i,xChannel})
        xChanID = strsplit(plotDef{i, xChannel}, '/');
        [xp, xMeta] = kVIS_fdsGetChannel(fds, xChanID{1}, xChanID{2});
        
        if xp == -1
            disp('x channel not found... Skipping.')
            k=k-1;
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
    yp = yp * plotDef{i,ScaleFactor};
    
    % apply function to data - fcnData content is given to function as
    % string to be processed inside fcn.
    if ~isnan(plotDef{i,fcnHandle})

        try
            [yp, xp2, plotFcnColors] = feval(plotDef{i,fcnHandle}, yp, fds, pts, plotDef{i,fcnChannel});
            if ~isempty(xp2)
                xp = xp2;
                xMeta.texName = 'frequency \; [Hz]';
            end
        catch ME
            ME.identifier
            disp('Function eval error... Ignoring.')
            k=k-1;
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
    if plotDef{i,AxesLayout} == 'L'
        yyaxis(ax, 'left')
    elseif plotDef{i,AxesLayout} == 'R'
        yyaxis(ax, 'right')
    else
        % single plot
    end

    % scatter plot
    if ~isnan(plotDef{i,cChannel})
        
        ccC = strsplit(plotDef{i, cChannel}, '/');
        
        [col] = kVIS_fdsGetChannel(fds, ccC{1}, ccC{2});
        
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
        
        p = plot(ax, xp, yp); 
        
        hold(ax, 'on');
        axis(ax, 'tight');
        
        p.LineWidth = 2.0;

    end
    
    
    %% annotations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isnan(plotDef{i, xAxisLabel})
        % generate (or ignore) custom x axis label
        if ~strcmp(plotDef{i, xAxisLabel},'none')
            xlabel(kVIS_generateLabels(plotDef{i, xAxisLabel}, []),'Interpreter','latex','FontSize',13)
        end
    else
        xlabel(kVIS_generateLabels(xMeta, []),'Interpreter','latex','FontSize',13)
    end
    
    % LabelOverride
    if ~isnan(plotDef{i, LabelOverride})
        yLabel = kVIS_generateLabels(plotDef{i, LabelOverride}, []);
    else
        yLabel = kVIS_generateLabels(yMeta, []);
    end
    
    % collect labels for legend/ylabel
    labelstr{k} = yLabel; %#ok<AGROW>
   
    if k == 1 % this doesn't work with yyaxis...
        ylabel(labelstr{k},'Interpreter','latex', 'FontSize', 13);
    else
        
        if ~isnan(plotDef{i, yAxisLabel})
            ylabel(kVIS_generateLabels(plotDef{i, yAxisLabel}, []),'Interpreter','latex', 'FontSize', 13);
        else
            ylabel([])
        end
        
        
        legend_handle = legend(ax, labelstr);
        
        if ~isnan(plotDef{i,LegendLocation})
            Style.Legend.Location = plotDef{i,LegendLocation};
        end
        
        if ~isnan(plotDef{i,LegendStyle})
            Style.Legend.Orientation = plotDef{i,LegendStyle};
        end
        
        kVIS_setGraphicsStyle(legend_handle, Style.Legend);
    end
    
    %% formatting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~isnan(plotDef{i,PlotStyle})
        p.LineStyle = plotDef{i,PlotStyle};
    end
    
    if ~isnan(plotDef{i,Color})
        p.Color = plotDef{i,Color};
    end
    
    grid(ax, 'on');
    
    ax.XRuler.Exponent = 0; % no exp in time stamps
    
    kVIS_setGraphicsStyle(ax, Style.Axes);
    
    %% save image(s) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fileNames{pltindex} = fullfile(outFolder, 'img', [pltName '_' num2str(pltindex) '.jpeg']);
    print(hh,'-noui',fileNames{pltindex}, '-djpeg', '-r200')
end

end