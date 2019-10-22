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

function fds = kVIS_fdsAddDataGroup(fds, groupName, leafName, varNames, varUnits, varFrames, fdata)
%
% add a group to tree, or update group if it exists
%

% check if node exists already
[~, nodeIndex] = kVIS_fdsGetGroup(fds, groupName);

if nodeIndex > 0
    
    [~, nodeIndex2] = kVIS_fdsGetGroup(fds, leafName);
    
    if nodeIndex2 > 0
        % overwrite existing data
        fds = kVIS_fdsReplaceTreeLeaf(fds, leafName, varNames, varNames, varUnits, varFrames, fdata, false);
    else
        fds = kVIS_fdsAddTreeLeaf(fds, leafName, varNames, varNames, varUnits, varFrames, fdata, nodeIndex, false);
    end
else
    % add tree node
    [fds, parentNode] = kVIS_fdsAddTreeBranch(fds, 0, groupName);
    fds = kVIS_fdsAddTreeLeaf(fds, leafName, varNames, varNames, varUnits, varFrames, fdata, parentNode, false);
end

end