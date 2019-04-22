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

function kVIS_setDataRange(hObject, select, value)

h = guidata(hObject);

switch select
    
    case 'XLim'
        
        h.uiDataRange.Xmin.String = num2str(value(1),'%.2f');
        h.uiDataRange.Xmax.String = num2str(value(2),'%.2f');
        
    case 'YlLim'
        
        if isempty(value)
            h.uiDataRange.YLmin.String = 'auto';
            h.uiDataRange.YLmax.String = 'auto';
        else
            h.uiDataRange.YLmin.String = num2str(value(1),'%.2f');
            h.uiDataRange.YLmax.String = num2str(value(2),'%.2f');
        end
        
    case 'YrLim'
        
        if isempty(value)
            h.uiDataRange.YRmin.String = 'auto';
            h.uiDataRange.YRmax.String = 'auto';
        else
            h.uiDataRange.YRmin.String = num2str(value(1),'%.2f');
            h.uiDataRange.YRmax.String = num2str(value(2),'%.2f');
        end
        
    case 'YtLim'
        
        h.uiDataRange.YTmin.String = num2str(value(1),'%.2f');
        h.uiDataRange.YTmax.String = num2str(value(2),'%.2f');
end

guidata(hObject, h);

end

