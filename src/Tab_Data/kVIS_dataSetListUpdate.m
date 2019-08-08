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

function [] = kVIS_dataSetListUpdate(hObject, select, name, ID)

h = guidata(hObject);

list = h.uiTabData.dataSetList;

switch select
    
    case 'add'
        % adds to the end and makes that entry current
        if isempty(list.String)
            list.String = {name};
        else
            list.String = [list.String; name];
        end
        
        list.Value  = size(list.String, 1);
        
    case 'delete'
        
        if ID == 1
            list.String = list.String(ID+1:end);
        else
            list.String = [list.String(1:ID-1) list.String(ID+1:end)];
        end
        
        list.Value = 1;
        
    case 'clear'
        
        list.String = {};
        list.Value = 0;
        
end

end

