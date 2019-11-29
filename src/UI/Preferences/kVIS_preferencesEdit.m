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

function kVIS_preferencesEdit(hObject, ~)

prefs = getpref('kVIS_prefs')

n = fieldnames(prefs);

for i = 1:length(n)
    d{i} = num2str(prefs.(n{i}));
end

res = inputdlg(n,'Test Information', 1, d, 'on')

if isempty(res)
    return
end

for i = 1:length(n)
    
    val = str2double(res{i});
    
    if isnan(val)
        val = res{i};
    end
    
    setpref('kVIS_prefs',n{i}, val);

end

prefs = getpref('kVIS_prefs')

end

