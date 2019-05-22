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

function [] = kVIS_clearPlotLim_Callback(hObject, ~, select)

h = guidata(hObject);
%
% clear selected fields in UI
%
switch select
    
    case 'XLim'
        
        lim = kVIS_fdsGetGlobalDataRange(hObject);
        
        h.uiDataRange.Xmin.String = lim(1);
        h.uiDataRange.Xmax.String = lim(2);
        
        kVIS_dataRangeUpdate_Callback(hObject, [], select);
        
    case 'YLim'
        
        h.uiDataRange.Ymin.String = 'auto';
        h.uiDataRange.Ymax.String = 'auto';
        
        kVIS_dataRangeUpdate_Callback(hObject, [], select);
        
        
    case 'all'
        
        lim = kVIS_fdsGetGlobalDataRange(hObject);
        h.uiDataRange.Xmin.String = lim(1);
        h.uiDataRange.Xmax.String = lim(2);
        
        kVIS_dataRangeUpdate_Callback(hObject, [], 'XLim');
        
        h.uiDataRange.Ymin.String = 'auto';
        h.uiDataRange.Ymax.String = 'auto';
        
        kVIS_dataRangeUpdate_Callback(hObject, [], 'YLim');
end

end

