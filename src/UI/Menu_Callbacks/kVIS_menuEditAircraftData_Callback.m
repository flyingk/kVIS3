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

function kVIS_menuEditAircraftData_Callback(hObject, ~)

[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    return
end

n = fieldnames(fds.aircraftData);

for i = 1:length(n)
    d{i} = num2str(fds.aircraftData.(n{i}));
end

res = inputdlg(n,'Aircraft Data', 1, d);


if isempty(res)
    return
end

for i = 1:length(n)
    
    val = str2double(res{i});
    
    if isnan(val)
        val = res{i};
    end
    
    fds.aircraftData.(n{i}) = val;

end

fds.aircraftData;

kVIS_updateDataSet(hObject, fds, name);

disp('kVIS_menuEditAircraftData_Callback: don''t load full fds...')
end

