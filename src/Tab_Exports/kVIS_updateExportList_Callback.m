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

EXPORTS = struct();

BSP_NAME = handles.bspInfo.Name;
BSP_Path = getpref('kVIS_prefs','bspDir');
BSP_Exports_Path = fullfile(BSP_Path, 'Exports');

if exist(BSP_Exports_Path, 'dir')
    
    list = dir(BSP_Exports_Path);
    ll = struct2cell(list);
    
    % get valid plot names
    aa = endsWith(ll(1,:), ".xlsx");
    
    EXPORTS.names = ll(1,aa);
    EXPORTS.BSP_Exports_Path = BSP_Exports_Path;
    
else
    disp('Exports folder not found...')
    return
end

handles.uiTabExports.Exports = EXPORTS;

handles.uiTabExports.exportListBox.Value = 1;
handles.uiTabExports.exportListBox.String = handles.uiTabExports.Exports.names;

guidata(hObject, handles);
end