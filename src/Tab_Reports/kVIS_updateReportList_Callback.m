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

function [] = kVIS_updateReportList_Callback(hObject, ~)

handles = guidata(hObject);

REPORTS = struct();

BSP_NAME = handles.bspInfo.Name;
BSP_Path = getpref('kVIS_prefs','bspDir');
BSP_Reports_Path = fullfile(BSP_Path, 'ReportGeneration');

if exist(BSP_Reports_Path, 'dir')
    
    list = dir(BSP_Reports_Path);
    ll = struct2cell(list);
    
    % get valid plot names
    aa = endsWith(ll(1,:), ".tex");
    
    REPORTS.names = ll(1,aa);
    REPORTS.BSP_Reports_Path = BSP_Reports_Path;
    
else
    disp('Reports folder not found...')
    return
end

handles.uiTabReports.Reports = REPORTS;

handles.uiTabReports.reportListBox.Value = 1;
handles.uiTabReports.reportListBox.String = handles.uiTabReports.Reports.names;

guidata(hObject, handles);
end