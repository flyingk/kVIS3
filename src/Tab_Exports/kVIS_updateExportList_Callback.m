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

function [] = kVIS_updateExportList_Callback(hObject, ~)

handles = guidata(hObject);

handles.uiTabExports.Exports = LoadPlotDefinitions(handles.preferences);



BSP_Name = fieldnames(handles.uiTabExports.Exports);

export_list = fieldnames(handles.uiTabExports.Exports.(BSP_Name{1}));



handles.uiTabExports.exportListBox.Value = 1;
handles.uiTabExports.exportListBox.String = export_list;


guidata(hObject, handles);
end


function [ EXPORTS ] = LoadPlotDefinitions(preferences)
%
% Load custom plot definitions provided by the BSP.
%

% Plot list to be filled in by plot definition scripts
EXPORTS = struct();

% Find custom plot definitions in each BoardSupportPackage and add them to the list as
% CUSTOM_PLOTS.(BSP_Name).(PlotName)

BSP_NAME = preferences.BSP_Info.Name;
BSP_Path = preferences.bsp_dir;
BSP_Exports_Path = fullfile(BSP_Path, 'Exports');


if exist(BSP_Exports_Path, 'dir')
    
    BSP_Export_Scripts = dir(BSP_Exports_Path);
    BSP_Export_Scripts = BSP_Export_Scripts(~[BSP_Export_Scripts(:).isdir]);
    
    % new spreadsheet based definition - exclude excel temp files
    BSP_Export_Scripts_xls = BSP_Export_Scripts(endsWith({BSP_Export_Scripts(:).name}, '.xlsx') & ...
        ~startsWith({BSP_Export_Scripts(:).name}, '~$'));
    
    for s = 1 : numel(BSP_Export_Scripts_xls)
        
        script_file = fullfile(BSP_Export_Scripts_xls(s).folder, BSP_Export_Scripts_xls(s).name);
        
        [~,~,export_definition] = xlsread(script_file,'','','basic');
        
        plt_name = export_definition{3,2};
        EXPORTS.(BSP_NAME).(plt_name) = export_definition;
    end
    
else
    disp('Export folder not found...')
end




end
