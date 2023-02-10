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

function kVIS_eventExportBatch_Callback(hObject,~)
%
% export event(s) as individual fds files
%

h = guidata(hObject);

% Loop through each of the data sets
for ii = 1:numel(h.uiTabData.dataSetList.String)

    % Set the data file
    h.uiTabData.dataSetList.Value = ii;

    % Run the standard export script
    kVIS_eventExport_Callback(hObject);

end

kVIS_terminalMsg('Export Complete.');

return
