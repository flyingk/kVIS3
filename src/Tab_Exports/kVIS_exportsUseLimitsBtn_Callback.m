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

function kVIS_exportsUseLimitsBtn_Callback(hObject, ~, reset)

handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

if hObject.Value == 0
    handles.uiTabExports.exportsUseLimitsBtn = 0;
    hObject.CData = imread('use_limits.png');
    guidata(hObject, handles)
else
    handles.uiTabExports.exportsUseLimitsBtn = 1;
    hObject.CData = imread('use_limits.png') - 30;
    guidata(hObject, handles)
    kVIS_exportsSnapshotsBtn_Callback(findobj('Tag','exportsSnapshotsBtn'), [], 1)
    kVIS_editExportDefBtn_Callback(findobj('Tag','editExportDefBtn'), [], 1)
end

end

