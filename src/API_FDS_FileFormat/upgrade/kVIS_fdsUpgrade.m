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

function [ fds ] = kVIS_fdsUpgrade(fds)
    % Upgrade FDS to current storage format.

    currentVersion = 1.0;

    assert(isstruct(fds), 'FDS must be a struct');

    if ~isfield(fds, 'fdsVersion')
        % legacy format
        fds.fdsVersion = -1;
    end

    while fds.fdsVersion < currentVersion
        switch fds.fdsVersion
        case 1.0
            fds = fds;
        case 0
            fds = kVIS_fdsUpgrade_V_0_V_1_0(fds);
        case -1
            fds = kVIS_fdsUpgradeLegacy(fds);
        otherwise
            error('Unsupported FDS version: %s', fds.fdsVersion);
        end
        if fds.fdsVersion >= 1.0
            kVIS_fdsValidate(fds);
        end
    end

end
