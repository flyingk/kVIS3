%
%> @file kVIS_getAllFds.m
%> @brief Return all open fds files with their names
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
%> @brief Return all open fds files with their names
%>
%> @param GUI handles
%>
%> @retval Cell array with fds structs
%> @retval Char vector with corresponding names
%> @retval Index of currently sleected list entry
%
function [fds, names, idxCurrent] = kVIS_getAllFds(hObject)

[idxCurrent, name, noOfEntries, str] = kVIS_dataSetListState(hObject);

if isempty(name)
    fds = -1;
    names = '';
    return
end

for I = 1:noOfEntries

    fname = strip(regexprep(str{I}, '\s.*$', ''));

    fds{I} = evalin('base', fname);

end

names = str;

end
