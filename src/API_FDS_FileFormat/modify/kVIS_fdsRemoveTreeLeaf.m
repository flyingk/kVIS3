%
%> @file kVIS_fdsRemoveTreeLeaf.m
%> @brief Removes a leaf from the fdata tree. Leafs contain data.
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
%> @brief Add new leaf to fdata tree. Leafs contain data.
%>
%> @param fds structure
%> @param Name of group to remove
%>
%> @retval Modified fds structure
%
function [ fds ] = kVIS_fdsRemoveTreeLeaf(fds, label)

% Index groups with matching names
idx = strcmp(label,fds.fdata(fds.fdataRows.groupLabel,:));

if max(idx) == 0
    % Group not found, do nothing
    fprintf('Group << %s >> not found in fds\n',label)
else
    % Update fdata without the indexed groups
    fds.fdata = fds.fdata(:,~idx);
end

return;
end
