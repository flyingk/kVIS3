%
%> @file kVIS_deleteTreeGroup_Callback.m
%> @brief Callback from tree context menu to delete tree item
%
%
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

%
%> @brief Callback from tree context menu to delete tree item
%>
%> @param Menu handle
%> @param ignored
%> @param App handle
%> @param Tree item ID to delete
%>
%
function kVIS_deleteTreeGroup_Callback(source, ~, hObject, itemID)

% menu entry - no use
source;

% fetch fds structure
[fds, name] = kVIS_getCurrentFds(hObject);

clc
tp = kVIS_fdsBuildTreePath(fds, itemID)
C = kVIS_fdsFindTreeChildren(fds, itemID)
return


% fds api call
[fds] = kVIS_fdsDeleteTreeItem(fds, itemID);

% update app if fds was modified
if isstruct(fds)
    kVIS_updateDataSet(hObject, fds, name);
end

end

