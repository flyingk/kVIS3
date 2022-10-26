%
%> @file kVIS_reportPlotGeneration.m
%> @brief Generate plots for a report from a custom plot definition
%
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
%> @brief Generate plots for a report from a custom plot definition
%>
%> @param hObject
%> @param Name of custom plot definition
%> @param Path of report output folder (plots will be generated in a subfolder ./img)
%
function fileNames = kVIS_reportPlotGeneration(hObject, plotName, plotSel, outFolder)

eventsToggle = 0;

try
    [fds, ~, idxFdsCurrent] = kVIS_getAllFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

%
% Read plot definition
%

if endsWith(plotName,".xlsx")
    try
        [~,~,plotDef] = xlsread(plotName,'','A:T','basic');
    catch
        errordlg('Plot definition does not exist.')
        fileNames = [];
        return
    end
end

%
% format figure
%
DefaultStyle = struct();
DefaultStyle.Figure = struct();
DefaultStyle.Figure.Color = 'w';

DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'k';
DefaultStyle.Axes.YColor = 'k';
DefaultStyle.Axes.GridColor = 'k';
DefaultStyle.Axes.MinorGridColor = 'k';

DefaultStyle.Legend.FontSize = 10;
DefaultStyle.Legend.Location = 'best';
DefaultStyle.Legend.Orientation = 'horizontal';
DefaultStyle.Legend.Interpreter = 'latex';

Style = DefaultStyle;


% % plot full data length
handles = guidata(hObject);

if handles.uiTabPlots.plotsUseLimitsBtn.Value == 0

    xlim = kVIS_fdsGetGlobalDataRange(hObject);

else % use X-Limits (if button pressed or for events)

    xlim = kVIS_getDataRange(hObject, 'XLim');

end

% get data content
% remove header
plotDef = plotDef(6:end,:);
% remove extra lines from below the data
rl = ~isnan(cell2mat(plotDef(:,1)));
plotDef = plotDef(rl==1,:);


oldpltindex = 0;
figs = [];
axlist = [];

interactiveToggle = false;

plotNo = 1;
ReportCaption=9;

for plotDefRowNo = 1:size(plotDef, 1)
    %% plot setup
    pltindex = plotDef{plotDefRowNo,plotNo};

    % generate only selected plots
    if ~isempty(plotNo)
        if isempty(find(plotSel==pltindex,1))
            continue;
        end
    end

    if pltindex ~= oldpltindex
        % next plot axes
        currentPlotLineNo = 1;
        clear p labelstr mm ma hh ax

        hh = figure('Position',[0 0 750 325],'Color','w','Visible','off');
        hh.Tag = 'cpTimeplot';
        hh.SizeChangedFcn = @kVIS_panelSizeChanged_Callback;

        ax = axes(hh, 'Units', 'normalized');

        grid(ax, 'on');
        figs = [figs, hh];
        axlist = [axlist, ax];
    else
        % continue in current axes
        currentPlotLineNo = currentPlotLineNo + 1;
    end

    oldpltindex = pltindex;

    [ax, error] = kVIS_customPlot(ax, fds, plotDef, plotDefRowNo, xlim, Style, idxFdsCurrent, interactiveToggle);

    if error > 0
        currentPlotLineNo = currentPlotLineNo - 1;
        continue;
    end

    caption{pltindex} = plotDef{plotDefRowNo, ReportCaption};

    ax.XRuler.Exponent = 0; % no exponent in time stamps

end

% add events if they have been selected
if eventsToggle == 1
    for I = 1:length(axlist)
        kVIS_eventPlot([], [], axlist(I), fds{idxFdsCurrent})
    end
end

%% save image(s) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:length(figs)
    fileNames{1,I} = fullfile(outFolder, 'img', [plotName '_' num2str(plotSel(I)) '.jpeg']);
    print(figs(I),'-noui',fileNames{1,I}, '-djpeg', '-r200')

    % relative path
    fileNames{1,I} = ['./img/' plotName '_' num2str(plotSel(I)) '.jpeg'];
    fileNames{2,I} = caption{plotSel(I)};
end

clear figs axlist

end