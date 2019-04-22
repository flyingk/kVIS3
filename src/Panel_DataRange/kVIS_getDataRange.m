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

function value = kVIS_getDataRange(hObject, select)

h = guidata(hObject);

switch select
    
    case 'XLim'
        
        value(1) = str2double(h.uiDataRange.Xmin.String);
        value(2) = str2double(h.uiDataRange.Xmax.String);
        
    case 'YlLim'
        
        value(1) = str2double(h.uiDataRange.YLmin.String);
        value(2) = str2double(h.uiDataRange.YLmax.String);
        
    case 'YrLim'
        
        value(1) = str2double(h.uiDataRange.YRmin.String);
        value(2) = str2double(h.uiDataRange.YRmax.String);
        
    case 'YtLim'
        
        value(1) = str2double(h.uiDataRange.YTmin.String);
        value(2) = str2double(h.uiDataRange.YTmax.String);
        
end

end

