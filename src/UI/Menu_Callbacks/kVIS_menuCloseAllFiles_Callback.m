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

function kVIS_menuCloseAllFiles_Callback(hObject, ~)

[~, name, noOfEntries, nameList] = kVIS_dataSetListState(hObject);

if isempty(name)
    disp('Nothing to clear. Abort.')
    return;
end

action = questdlg( ...
    sprintf('Delete flight data from the workspace?'), ...
    sprintf('Close all flights'), ...
    'Close and keep data', 'Close and delete data', 'Cancel', ...
    'Close and keep data' ...
    );

if strcmp(action, 'Cancel')
    return
end

% delete files in base workspace
if strcmp(action, 'Close and delete data')
    
    for k = 1 : noOfEntries
        name = nameList{k};
        evalin('base', sprintf('clear %s;', name));
    end
    
end

% reset app
kVIS_dataSetListUpdate(hObject, 'clear', []);

kVIS_groupTreeUpdate(hObject, []);
kVIS_updateChannelList_Callback(hObject, []);

kVIS_clearPlot_Callback(hObject, []);

kVIS_updateEventList(hObject, [], true);

end