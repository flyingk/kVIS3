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

function [ fds, node ] = kVIS_fdsAddTreeBranch(fds, level, name)
%
% Add new branch to fdata tree. Branches have name and level only, no data
%

%
% Check if group exists
%
[~, node] = kVIS_fdsGetGroup(fds, name);

%
% create, if not
%
if node <= 0
    
    % first entry - new root level node
    if size(fds.fdata, 2) == 1  && isempty(fds.fdata{fds.fdataRows.groupLabel, 1})
        
        fds.fdata{fds.fdataRows.groupLabel, 1} = name;
        fds.fdata{fds.fdataRows.treeParent, 1} = 0;
        fds.fdata{fds.fdataRows.treeGroupSelected, 1} = false;
        
    else % add fdata column and populate
        
        fds.fdata = [fds.fdata cell(10,1)];
        
        fds.fdata{fds.fdataRows.groupLabel, end} = name;
        fds.fdata{fds.fdataRows.treeParent, end} = level;
        fds.fdata{fds.fdataRows.treeGroupSelected, end} = false;
    end
    
    % number of this node
    node = size(fds.fdata, 2);
    
end