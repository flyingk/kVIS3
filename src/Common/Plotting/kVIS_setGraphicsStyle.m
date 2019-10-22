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

function [ ] = kVIS_setGraphicsStyle(graphics_handle, attributes)
    % Set attributes of Matlab graphics objects.
    % This is a wrapper around set(graphics_handle, 'key', 'value', ...) that
    % accepts attributes specified as struct('key', 'value', ...) which is more
    % convenient when passing style specifications around between functions.

    assert(all(isvalid(graphics_handle)));
    assert(isstruct(attributes));

    % Transform the given struct with key-value pairs into a cell array,
    % e.g. struct('a', 1, 'b', 2, c, 3) --> {'a', 1, 'b', 2, 'c', 3}.
    % The elements of the cell array can then be used as inputs to set(...).
    N = numel(fieldnames(attributes));
    args = cell(1, 2 * N);
    args(1:2:end-1) = fieldnames(attributes);
    args(2:2:end)   = cellfun(@(x) attributes.(x), args(1:2:end-1), 'UniformOutput', false);

    if numel(args) > 0
        set(graphics_handle, args{:});
    end

end
