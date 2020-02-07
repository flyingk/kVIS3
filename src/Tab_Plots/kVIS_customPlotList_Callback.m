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

function kVIS_customPlotList_Callback(hObject, ~, plotName)

% get GUI data
handles = guidata(hObject);

% get menu entry - plot selection
val = hObject.Value;

plotName = hObject.String{val};


if isempty(plotName)
    
    % edit the plot definition file, if selected
    if handles.uiTabPlots.editPlotDefBtn == 1
        
        BSP_Path = getpref('kVIS_prefs','bspDir');
        BSP_CustomPlots_Path = fullfile(BSP_Path, 'CustomPlots');
        plot_def_full = [BSP_CustomPlots_Path '/' plotName '_Plot_Def.xlsx'];
        
        % Platform specific command
        if (ismac)
            cmdstr = ['open ' plot_def_full];
        elseif (ispc)
            cmdstr = ['',plot_def_full,'',' &']; % Open in background
            %cmdstr = ['',plot_def_full,''];      % Open in foreground
        elseif (isunix)
            disp('Platform not yet supported!');
        else
            disp('Platform not supported!');
            return
        end
        
        rc = system(cmdstr);
        
        if rc ~= 0
            disp('Plot definition file (.xlsx) not found. Opening folder instead...')
            cmdstr = ['open ' BSP_CustomPlots_Path];
            system(cmdstr);
        end
        
        kVIS_editCustomPlotDefBtn_Callback(findobj('Tag','editPlotDefBtn'), [], 1)
        
        return
    end
end

try
    [fds, fds_name] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

%
% Read plot definition
%
PlotDefinition = handles.uiTabPlots.CustomPlots;

file = [PlotDefinition.BSP_CustomPlots_Path '/' plotName];

if endsWith(file,".xlsx")
    [~,~,PlotDefinition] = xlsread(file,'','','basic');
elseif endsWith(file,".m")
    BSP_NAME = 'none';
    run(file)
end


% % plot full data length
if handles.uiTabPlots.plotsUseLimitsBtn.Value == 0
    
    xlim = kVIS_fdsGetGlobalDataRange(hObject);
    
else % use X-Limits (if button pressed or for events)
    
    xlim = kVIS_getDataRange(hObject, 'XLim');
    
end
tic

hh = msgbox('Creating Plot...');

if size(PlotDefinition, 2) < 19
    % Create a new figure and format it
    finp = figure('Position',[100,100,1000,800],'Units','normalized',...
        'Visible','off');
        
    kVIS_generateCustomPlotM(finp, fds, plot_definition, xlim, []);
else
    % Create a new figure and format it
    finp = figure('Position',[100,100,PlotDefinition{3,5},PlotDefinition{3,6}],...
        'Units','normalized','Name',[fds_name ': ' PlotDefinition{3,2}],...
        'NumberTitle','off',...
        'Visible','off');
    
    kVIS_generateCustomPlotXLS(finp, fds, PlotDefinition, xlim, []);
end
toc
%
% show plot figure
%
finp.Visible = 'on';
delete(hh);

end

