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

function kVIS_fdsValidate(fds, varargin)
    % Validate a given FDS struct against the format specification:
    %   fdsValidate(fds)            --> validate against version specified in fds
    %   fdsValidate(fds, 'fds')     --> validate against version specified in fds
    %   fdsValidate(fds, version)   --> validate against specific version
    %   fdsValidate(fds, 'current') --> validate against current version
    % Throws an error if invalid.
    % By default, validates against the version specified in the FDS. If the
    % FDS is valid, fds_upgrade(fds) must produce a valid FDS matching the
    % current specification.

    argParser = inputParser();
    argParser.KeepUnmatched = false;
    argParser.StructExpand  = true;
    argParser.addOptional('Version', 'fds', @(x) isnumeric(x) | ischar(x));

    argParser.parse(varargin{:});
    args = argParser.Results;

    assert(isstruct(fds), 'FDS must be a struct, got a %s', class(fds));

    switch args.Version
    case 'fds'
        % use version specified by fds
        if ~isfield(fds, 'fdsVersion')
            error('Trying to validate a legacy FDS, for which no specification exists.');
        end
        kVIS_fdsValidate(fds, fds.fdsVersion);
    case {1.0, 'current'}
        kVIS_fdsValidate_V_1_0(fds);
    otherwise
        error('Invalid version specified');
    end

end
