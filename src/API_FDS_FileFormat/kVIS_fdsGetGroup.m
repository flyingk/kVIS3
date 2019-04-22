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

function [data, index] = kVIS_fdsGetGroup(fds, field_name)
% Finds a match for the field name and gives you the output

if ~nargin
    disp('No fds structure specified...')
    data = -1;
    index = -1;
    return
end

% Find the correct index by trying to match the name
i=1;

while (strcmp(fds.fdata{1,i},field_name) ~=1)
    i=i+1;
    
    % Check if we've reached the end of the data set
    if (i > length(fds.fdata))
        fprintf('Data file name %s does not exist\n',field_name);
        data = -1;
        index = -1;
        return
    end
    
end

% Index found, get the data
data = fds.fdata{fds.fdataRows.data,i};
index = i;

return
end
