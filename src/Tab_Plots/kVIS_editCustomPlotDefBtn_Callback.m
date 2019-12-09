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

function kVIS_editCustomPlotDefBtn_Callback(hObject, ~, reset)

handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

if hObject.Value == 0
    handles.uiTabPlots.editPlotDefBtn = 0;
    hObject.CData = imread('icons8-edit-36.png');
else
    handles.uiTabPlots.editPlotDefBtn = 1;
     hObject.CData = imread('icons8-edit-36_p.png') - 10;
end

% Open Excel plot def file.
% The file needs to be named bsp_dir\CustomPlots\PLOT_NAME.xlsx
excel_path = '"C:\Program Files\Microsoft Office\root\Office16\EXCEL.exe"';
plot_def_path = [getpref('kVIS_prefs', 'bspDir'),'\CustomPlots\'];
plot_def_file = [handles.uiTabPlots.customPlotListBox.String{handles.uiTabPlots.customPlotListBox.Value},'.xlsx'];
plot_def_full = ['"',plot_def_path,plot_def_file,'"'];

% ToDo: Put a check in here to make sure the files are named correctly as
% the plot name sanitiser might have changed something...
fprintf('Opening file %s\n',plot_def_full);
system(['', excel_path,' /t ',plot_def_full,'']);

guidata(hObject, handles)
end

