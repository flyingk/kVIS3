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

function kVIS_addDataSet(hObject, fds, fdsName)

% Updates the workspace and GUI

%
% generate data set name
%
[~, ~, noOfEntries] = kVIS_dataSetListState(hObject);

if noOfEntries == 0
    flightNo = 1;
else
    flightNo = noOfEntries + 1;
end

flightVar = ['Flight_' num2str(flightNo)];

if ~isempty(fdsName)
    flightVar = fdsName;
end

kVIS_dataSetListUpdate(hObject, 'add', flightVar);
%
% process signal descriptions
%
fds = kVIS_fdsGenerateTexLabels(fds);
%
% save fds to workspace
%
assignin('base', flightVar, fds);
%
% update group tree
%
kVIS_groupTreeUpdate(hObject, fds);
%
% Fill event table
%
kVIS_updateEventList(hObject, fds.eventList, false);
% 
% Update UI lists
%
kVIS_updateCustomPlotList_Callback(hObject, []);
kVIS_updateExportList_Callback(hObject, []);

%
% set limit boxes to new values
%
kVIS_setDataRange(hObject, 'XLim', kVIS_fdsGetGlobalDataRange(hObject));
kVIS_setDataRange(hObject, 'YlLim', []);

end
