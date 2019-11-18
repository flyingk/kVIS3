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

function [] = kVIS_updateCustomPlotList_Callback(hObject, ~)

handles = guidata(hObject);

handles.uiTabPlots.CustomPlots = LoadPlotDefinitions(handles.preferences);



BSP_Name = fieldnames(handles.uiTabPlots.CustomPlots);

custom_plot_list = fieldnames(handles.uiTabPlots.CustomPlots.(BSP_Name{1}));



handles.uiTabPlots.customPlotListBox.Value = 1;
handles.uiTabPlots.customPlotListBox.String = custom_plot_list;


guidata(hObject, handles);
end


function [ CUSTOM_PLOTS ] = LoadPlotDefinitions(preferences)
%
% Load custom plot definitions provided by the BSP.
%

% Plot list to be filled in by plot definition scripts
CUSTOM_PLOTS = struct();

% Find custom plot definitions in each BoardSupportPackage and add them to the list as
% CUSTOM_PLOTS.(BSP_Name).(PlotName)

BSP_NAME = preferences.BSP_Info.Name;
BSP_Path = preferences.bsp_dir;
BSP_CustomPlots_Path = fullfile(BSP_Path, 'CustomPlots');


if exist(BSP_CustomPlots_Path, 'dir')
    
    BSP_CustomPlot_Scripts = dir(BSP_CustomPlots_Path);
    BSP_CustomPlot_Scripts = BSP_CustomPlot_Scripts(~[BSP_CustomPlot_Scripts(:).isdir]);
    
    % legacy m-code format
    BSP_CustomPlot_Scripts_m = BSP_CustomPlot_Scripts(endsWith({BSP_CustomPlot_Scripts(:).name}, '.m'));
    
    for s = 1 : numel(BSP_CustomPlot_Scripts_m)
        
        script_file = fullfile(BSP_CustomPlot_Scripts_m(s).folder, BSP_CustomPlot_Scripts_m(s).name);
        % A custom plot definition script can generate one or more plot
        % definitions and add them to CUSTOM_PLOTS:
        %   CUSTOM_PLOTS.(BSP_NAME).NewPlotName = NewPlotDefinition;
        % The script is executed in the current local workspace.
        run(script_file);
    end
    
    % new spreadsheet based definition - exclude excel temp files
    BSP_CustomPlot_Scripts_xls = BSP_CustomPlot_Scripts(endsWith({BSP_CustomPlot_Scripts(:).name}, '.xlsx') & ...
        ~startsWith({BSP_CustomPlot_Scripts(:).name}, '~$'));
    
    for s = 1 : numel(BSP_CustomPlot_Scripts_xls)
        
        script_file = fullfile(BSP_CustomPlot_Scripts_xls(s).folder, BSP_CustomPlot_Scripts_xls(s).name);
        
        [~,~,plot_definition] = xlsread(script_file,'','','basic');
        
        plt_name = matlab.lang.makeValidName(plot_definition{3,2});
        CUSTOM_PLOTS.(BSP_NAME).(plt_name) = plot_definition;
    end
    
else
    disp('Custom plot folder not found...')
end




end
