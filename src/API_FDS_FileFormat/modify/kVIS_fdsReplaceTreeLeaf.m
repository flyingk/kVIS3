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

function [ fds ] = kVIS_fdsReplaceTreeLeaf(fds, label, vars, varsDisp, units, frame, data, selected)

%
% Replace an existing leaf of the fdata tree. Leafs contain data.
%

% find index of group to replace
[~, index] = kVIS_fdsGetGroup(fds, label);

 % first entry - new root level node
if index > 0
    
    fds.fdata{fds.fdataRows.groupLabel, index}   = label;
    fds.fdata{fds.fdataRows.varNames, index}     = vars;
    fds.fdata{fds.fdataRows.varUnits, index}     = units;
    fds.fdata{fds.fdataRows.varFrames, index}    = frame;
    fds.fdata{fds.fdataRows.varNamesDisp, index} = varsDisp;
    fds.fdata{fds.fdataRows.data, index}         = data;
    fds.fdata{fds.fdataRows.treeGroupSelected, index} = selected;
    
else
    
    disp('Leaf replace failed...')
    return
    
end