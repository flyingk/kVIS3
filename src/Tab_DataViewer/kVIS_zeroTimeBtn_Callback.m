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

function kVIS_zeroTimeBtn_Callback(hObject, ~)

[~, currentName, ~, ~] = kVIS_dataSetListState(hObject);

dataRange = kVIS_fdsGetGlobalDataRange(hObject);


if hObject.Value == 1
    
    command = sprintf([currentName '.timeOffset = ' num2str(dataRange(1)) ';']);
    
elseif hObject.Value == 0
    
    command = sprintf([currentName '.timeOffset = 0;']);

end


evalin('base', command);

end

