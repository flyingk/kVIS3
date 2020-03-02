%
%> @file kVIS_preferencesEdit.m
%> @brief Display window to change preferences
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
%> @brief Display window to change preferences
%>
%
function kVIS_preferencesEdit(~, ~)

prefs = getpref('kVIS_prefs');

n = fieldnames(prefs);

for i = 1:length(n)
    d{i} = num2str(prefs.(n{i}));
end

res = inputdlg(n,'Preferences', 1, d, 'on');

if isempty(res)
    return
end

for i = 1:length(n)
    
    val = str2double(res{i});
    
    if isnan(val)
        val = res{i};
    end

    if strcmp(n{i}, 'uiBackgroundColour')
        val = sscanf(res{i}, '%f %f %f')';
    end
    
    setpref('kVIS_prefs',n{i}, val);

end

prefs = getpref('kVIS_prefs');

msgbox('Changes take effect after restart.')

end

