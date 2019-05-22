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

function [] = kVIS_dataRangeUpdate_Callback(hObject, ~, select)

% h = guidata(hObject);

targetPanel = kVIS_dataViewerGetActivePanel;

if isempty(targetPanel)
    return
end

targetAxes = targetPanel.axesHandle;

switch select
    
    case 'XLim'
        
        xlim = kVIS_getDataRange(hObject, 'XLim');
        
        if xlim(1) > xlim(2)
            errordlg('Time Limits must be increasing...')
            return
        end
        
        targetAxes.XLim = xlim;

    case 'YLim'
        
        ylim = kVIS_getDataRange(hObject, 'YLim');
        
        if ylim(1) > ylim(2)
            errordlg('Vertical Limits must be increasing...')
            return
        end
        
        if isnan(ylim)
            % auto limits
            targetAxes.YLim = [-inf inf];
        else
            % as specified - replace 'auto' fields with inf
            if isnan(ylim(1))
                ylim(1) = -inf;
            elseif isnan(ylim(2))
                ylim(2) = inf;
            end
            
            targetAxes.YLim = ylim;
        end
        
        
end

targetPanel.plotChanged = randi(10000);

end

