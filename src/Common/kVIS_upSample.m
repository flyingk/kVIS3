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

function [signalNew, tNew] = kVIS_upSample(signal, ts, fsNew)
%
% upsample data
%
% Inputs:
%
% signal: original data as column array
% ts    : original time vector
% fsNew : desired sample rate (scalar) or new time vector (column vector)
%

%
% check fsNew type
%
if isscalar(fsNew)
    % generate new time vector with sample rate fsNew
    tNew = ts(1):1/fsNew:ts(end);
    tNew = tNew';
else
    % use provided time vector
    tNew = fsNew;
end

% upsample signal with new time vector
signalNew = interp1(ts, signal, tNew, 'pchip');

end

