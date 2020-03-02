%
%> @file kVIS_fdsAddDataGroup.m
%> @brief Add a group to tree, or update group if it exists
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
%> @brief Add a group to tree, or update group if it exists
%>
%> @param fds structure
%> @param Name of parent node
%> @param Name of new group
%> @param Cell array of channel names
%> @param Cell array of channel units
%> @param Cell array of channel frames
%> @param Array of channel data (time as first cannel)
%>
%> @retval Modified fds structure
%
function fds = kVIS_fdsAddDataGroup(fds, parentNode, groupName, varNames, varUnits, varFrames, fdata)

% check if node exists already
[~, nodeIndex] = kVIS_fdsGetGroup(fds, parentNode);

if nodeIndex > 0
    
    [~, nodeIndex2] = kVIS_fdsGetGroup(fds, groupName);
    
    if nodeIndex2 > 0
        % overwrite existing data
        fds = kVIS_fdsReplaceTreeLeaf(fds, groupName, varNames, varNames, varUnits, varFrames, fdata, false);
    else
        fds = kVIS_fdsAddTreeLeaf(fds, groupName, varNames, varNames, varUnits, varFrames, fdata, nodeIndex, false);
    end
else
    % add tree node
    [fds, parentNode] = kVIS_fdsAddTreeBranch(fds, 0, parentNode);
    fds = kVIS_fdsAddTreeLeaf(fds, groupName, varNames, varNames, varUnits, varFrames, fdata, parentNode, false);
end

end