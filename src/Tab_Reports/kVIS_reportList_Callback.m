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

function kVIS_reportList_Callback(hObject, ~)

% get GUI data
handles = guidata(hObject);


% get menu entry - plot selection
val = hObject.Value;

reportName = hObject.String{val};

% edit the plot definition file, if selected
if handles.uiTabReports.editReportDefBtn == 1
    
    BSP_Path = getpref('kVIS_prefs','bspDir');
    BSP_Reports_Path = fullfile(BSP_Path, 'ReportGeneration');
    
    if (ismac)
        cmdstr = ['open ' BSP_Reports_Path '/' reportName];
        
        rc = system(cmdstr);
    elseif (ispc)
        winopen([BSP_Reports_Path '\' reportName]);
        rc = 0;
    else
        disp('Platform not supported!');
        return
    end
    
    if rc ~= 0
        disp('Report definition file (.tex) not found. Opening folder instead...')
        cmdstr = ['open ' BSP_Reports_Path];
        system(cmdstr);
    end
    
    kVIS_editReportDefBtn_Callback(findobj('Tag','editReportDefBtn'), [], 1)
    
    return
end


try
    fds = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

%
% Read report definition
%
ReportDefinition = handles.uiTabReports.Reports;

file = [ReportDefinition.BSP_Reports_Path '/' reportName];

if ~endsWith(file,".tex")
    errordlg('Invalid report definition file type.')
    return
end

kVIS_generateReport(hObject, file)
