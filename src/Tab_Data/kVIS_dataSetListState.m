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

function [currentVal, currentName, noOfEntries, str] = kVIS_dataSetListState(hObject)

h = guidata(hObject);

list = h.uiTabData.dataSetList;

str = list.String;

if ~isempty(str)
    currentVal = list.Value;
    currentName = str{currentVal};
    noOfEntries = size(list.String, 1);
else
    currentName = '';
    currentVal = 0;
    noOfEntries = 0;
end

end

