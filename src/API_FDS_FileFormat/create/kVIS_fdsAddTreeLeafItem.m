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

function [ fds ] = kVIS_fdsAddTreeLeafItem(fds, group, var, varDisp, unit, frame, data)

%
% Add new data to a tree leaf.
%
fds.fdata{fds.fdataRows.varNames, group}     = [fds.fdata{fds.fdataRows.varNames, group}; {var}];
fds.fdata{fds.fdataRows.varUnits, group}     = [fds.fdata{fds.fdataRows.varUnits, group}; unit];
fds.fdata{fds.fdataRows.varFrames, group}    = [fds.fdata{fds.fdataRows.varFrames, group}; frame];
fds.fdata{fds.fdataRows.varNamesDisp, group} = [fds.fdata{fds.fdataRows.varNamesDisp, group}; {varDisp}];
fds.fdata{fds.fdataRows.data, group}         = [fds.fdata{fds.fdataRows.data, group}  data];

end

