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

function handles = kVIS_uiSetupMenu(handles, kVIS_Data)


% custom menu
m1 = uimenu(handles.appWindow,'Text','File');

m11 = uimenu(m1,'Text','Import');
% import fds already in matlab workspace
uimenu(m11,'Text','Existing Workspace FDS','Callback', @kVIS_menuImportWorkspaceFDS_Callback);
% generic csv import
% uimenu(m11,'Text','CSV File','Callback', @import_CSV_Callback);
% add BSP import function(s)
uimenu(m11,'Text','BSP functions:','Enable','off','Separator','on');
for i=1:size(kVIS_Data.BSP_Info.importFcn,1)
    uimenu(m11,'Text',kVIS_Data.BSP_Info.importFcn{i,1},'Callback',str2func(kVIS_Data.BSP_Info.importFcn{i,2}));
end

uimenu(m1,'Text','Open FDS file (.mat)','Callback',@kVIS_menuFileOpen_Callback);
uimenu(m1,'Text','Save Current Dataset As','Callback',@kVIS_menuSaveCurrentFile_Callback);
% uimenu(m1,'Text','Save Current As','Callback',@file_save_current_as_Callback);
% uimenu(m1,'Text','Save All As','Callback',@file_save_all_Callback);
% uimenu(m1,'Text','Close Current','Callback',@file_close_current_Callback);
uimenu(m1,'Text','Close All Dataset(s)','Callback',@kVIS_menuCloseAllFiles_Callback);
uimenu(m1,'Text','Quit','Callback',@kVIS_menuQuitButton_Callback);

m2 = uimenu(handles.appWindow,'Text','Edit');
uimenu(m2,'Text','Edit Aircraft Data', 'Callback', @kVIS_menuEditAircraftData_Callback);
uimenu(m2,'Text','Edit Test Information', 'Callback', @kVIS_menuEditTestInfo_Callback);
% m21 = uimenu(m2,'Text','Edit Timeline');
% m211 = uimenu(m21,'Text','Apply Cut','Callback',@cut_apply_Callback);
% m212 = uimenu(m21,'Text','Apply Cut + Save','Callback',@cut_apply_save_Callback);
% m213 = uimenu(m21,'Text','Mark Armed Region','Callback',@cut_mark_armed_Callback);
uimenu(m2,'Text','Rename Current Dataset','Callback',@kVIS_menuRenameDataSet_Callback);
% m23= uimenu(m2,'Text','Set Time Offset','Callback',@data_range_offset_Callback);

m3 = uimenu(handles.appWindow,'Text','View');
% uimenu(m3,'Text','Legend');
% uimenu(m3,'Text','Legend Font Size');
uimenu(m3,'Text','Tree Expand','Callback',@kVIS_treeExpandTree_Callback);
uimenu(m3,'Text','Tree Collapse','Callback',@kVIS_treeCollapseTree_Callback);
uimenu(m3,'Text','Tree Font Size','Callback',@kVIS_treeChangeFontSize_Callback);
% uimenu(m3,'Text','Grid Toggle','Callback',@grid_Callback);
% uimenu(m3,'Text','Map', 'Callback',@update_map_Callback);
% uimenu(m3,'Text','Timing Check','Callback',@time_base_Callback);

m4 = uimenu(handles.appWindow,'Text','Events');
% m41= uimenu(m4,'Text','Import Event List');
% m42= uimenu(m4,'Text','New Event','Callback',@event_create_Callback);
% m43= uimenu(m4,'Text','Edit Event','Callback',@event_edit_Callback);
% m44= uimenu(m4,'Text','Merge Events','Callback',@event_merge_Callback);
% m45= uimenu(m4,'Text','Delete Event','Callback',@event_delete_Callback);

m5 = uimenu(handles.appWindow,'Text','Plots');
% uimenu(m5,'Text','Reload Custom Plot Definitions','Callback', @reload_custom_plots_Callback);
% uimenu(m5,'Text','Plot All','Callback', @generate_all_custom_plots_Callback);

m6 = uimenu(handles.appWindow,'Text','Exports');
% m61= uimenu(m6,'Text','Export Current Plot','Callback',@export_plot_Callback);
% uimenu(m6,'Text','Reload Export Definitions','Callback', @reload_exports_Callback);
% m63= uimenu(m6,'Text','Export Data Format');
% m631= uimenu(m63,'Text','Matrix','Checked','on');
% % handles.ExportFormatSelector = 'matrix'; % default export format
% m632= uimenu(m63,'Text','Vectors','Callback',@export_vectors_Callback);
% m633= uimenu(m63,'Text','CSV');
% m634= uimenu(m63,'Text','tscollection');
% m635= uimenu(m63,'Text','Timeseries Object');
% m64= uimenu(m6,'Text','Event Auto Cutdown','Callback',@event_cutdown_Callback);

m7 = uimenu(handles.appWindow,'Text','BSP Add-Ons');
% menu entries from BSP Info
for i=1:size(kVIS_Data.BSP_Info.addOns,1)
    uimenu(m7,'Text',kVIS_Data.BSP_Info.addOns{i,1},'Callback',str2func(kVIS_Data.BSP_Info.addOns{i,2}));
end

m8 = uimenu(handles.appWindow,'Text','Help');
uimenu(m8,'Text','kVIS Help','Callback', @kVIS_help_Callback);
uimenu(m8,'Text','BSP Help','Callback', @BSP_help_Callback);
uimenu(m8,'Text','About','Callback', @kVIS_about_Callback);