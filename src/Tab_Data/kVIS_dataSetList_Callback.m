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

function [] = kVIS_dataSetList_Callback(hObject, ~)

%
% retrieve selected file
%
fds = kVIS_getCurrentFds(hObject);

if ~isstruct(fds)
    return
end
%
% update group tree
%
kVIS_groupTreeUpdate(hObject, fds, 'default');

%
% Fill event table
%
kVIS_updateEventList(hObject, fds.eventList, false);
% 
% % Update lists
% handles = update_custom_plot_list(handles);
% handles = UpdateExportList(handles);

%
% set limit boxes to new values
%
kVIS_setDataRange(hObject, 'XLim', [min(fds.fdataAttributes.startTimes) max(fds.fdataAttributes.stopTimes)]);
kVIS_setDataRange(hObject, 'YlLim', []);

end

