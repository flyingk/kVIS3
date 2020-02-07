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

function kVIS_menuDataSetTimeOffset_Callback(hObject, ~)
%
% apply time offset to entire data set
%

%
% get current selection
% 
[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    return
end

timeOffset = inputdlg({'New time offset [sec]:'}, 'Time Offset', 1, {'0.0'});

% cancel
if isempty(timeOffset)
    return
end

for I = 1 : size(fds.fdata, 2)
    
    if isempty(fds.fdata{fds.fdataRows.data, I})
        continue;
    end
    
    %
    % relate time to data samples
    %
    fds.fdata{fds.fdataRows.data, I}(:,1) = fds.fdata{fds.fdataRows.data, I}(:,1) + str2double(timeOffset);
    
end

%
% Update attributes
%
fds = kVIS_fdsUpdateAttributes(fds);

%
% save fds to workspace
%
assignin('base', name, fds);

%
% set limit boxes to new values
%
kVIS_setDataRange(hObject, 'XLim', kVIS_fdsGetGlobalDataRange(hObject));
kVIS_setDataRange(hObject, 'YlLim', []);


msgbox('Time offset successful.')
end

