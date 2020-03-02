%
%> @file kVIS_fdsAddTreeLeaf.m
%> @brief Add new leaf to fdata tree. Leafs contain data.
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
%> @param Name of new group
%> @param Cell array of channel names
%> @param Cell array of channel display names
%> @param Cell array of channel units
%> @param Cell array of channel frames
%> @param Array of channel data (time as first cannel)
%> @param Name of parent node
%> @param Selected flag
%>
%> @retval Modified fds structure
%> @retval New node index
%
function [ fds, node ] = kVIS_fdsAddTreeLeaf(fds, label, vars, varsDisp, units, frame, data, parent, selected)

 % first entry - new root level node
if size(fds.fdata, 2) == 1 && isempty(fds.fdata{fds.fdataRows.groupLabel, 1}) % first entry - new root level node
    
    fds.fdata{fds.fdataRows.groupLabel, 1}   = label;
    fds.fdata{fds.fdataRows.varNames, 1}     = vars;
    fds.fdata{fds.fdataRows.varUnits, 1}     = units;
    fds.fdata{fds.fdataRows.varFrames, 1}    = frame;
    fds.fdata{fds.fdataRows.varNamesDisp, 1} = varsDisp;
    fds.fdata{fds.fdataRows.data, 1}         = data;
    fds.fdata{fds.fdataRows.treeParent, 1}   = 0;
    fds.fdata{fds.fdataRows.treeGroupSelected, 1} = false;
    
else % add fdata column and populate
    
    fds.fdata = [fds.fdata cell(10,1)];
    
    fds.fdata{fds.fdataRows.groupLabel, end}   = label;
    fds.fdata{fds.fdataRows.varNames, end}     = vars;
    fds.fdata{fds.fdataRows.varUnits, end}     = units;
    fds.fdata{fds.fdataRows.varFrames, end}    = frame;
    fds.fdata{fds.fdataRows.varNamesDisp, end} = varsDisp;
    fds.fdata{fds.fdataRows.data, end}         = data;
    fds.fdata{fds.fdataRows.treeParent, end}   = parent;
    fds.fdata{fds.fdataRows.treeGroupSelected, end} = selected;
    
end

% number of this node
node = size(fds.fdata, 2);