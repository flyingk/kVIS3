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

function [ lines ] = kVIS_findValidPlotLines(axes_handle)
    % This function returns handles to all lines in the given axes that provide
    % struct data in the UserData field. This is intended to protect other
    % functions against lines that were not plotted by PlotSignal and thus have
    % no metadata.

    %
    % get all line objects
    %
    lines = findall(axes_handle, 'Type', 'Line');
    %
    % check for user data
    %
    valid_lines = arrayfun(@(x) isstruct(x.UserData), lines);
    
    if any(~valid_lines)
        warning('Found lines without metadata in the plot.');
        lines = lines(valid_lines);
    end

end
