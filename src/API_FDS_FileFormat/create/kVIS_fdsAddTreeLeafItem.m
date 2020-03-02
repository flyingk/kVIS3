%
%> @file kVIS_fdsAddTreeLeafItem.m
%> @brief Add new data to an existing tree leaf.
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
%> @brief Add new data to an existing tree leaf.
%>
%> @param fds structure
%> @param Name of group to update
%> @param Cell array of channel names
%> @param Cell array of channel display names
%> @param Cell array of channel units
%> @param Cell array of channel frames
%> @param Array of channel data (time as first cannel)
%>
%> @retval Modified fds structure
%
function [ fds ] = kVIS_fdsAddTreeLeafItem(fds, groupName, var, varDisp, unit, frame, data)

fds.fdata{fds.fdataRows.varNames, groupName}     = [fds.fdata{fds.fdataRows.varNames, groupName}; {var}];
fds.fdata{fds.fdataRows.varUnits, groupName}     = [fds.fdata{fds.fdataRows.varUnits, groupName}; unit];
fds.fdata{fds.fdataRows.varFrames, groupName}    = [fds.fdata{fds.fdataRows.varFrames, groupName}; frame];
fds.fdata{fds.fdataRows.varNamesDisp, groupName} = [fds.fdata{fds.fdataRows.varNamesDisp, groupName}; {varDisp}];
fds.fdata{fds.fdataRows.data, groupName}         = [fds.fdata{fds.fdataRows.data, groupName}  data];

end

