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

function kVIS_zoomMenu_Callback(hObject, ~, select)
%
% Callback for zoom menu
%
handles = guidata(hObject);

zoomHandle = handles.uiFramework.zoomHandle;

switch select
    
    case 'in'
        
        handles.uiFramework.zcmIN.Checked = 'on';
        handles.uiFramework.zcmOUT.Checked = 'off';
        
        zoomHandle.Direction = 'in';
        
    case 'out'
        
        handles.uiFramework.zcmIN.Checked = 'off';
        handles.uiFramework.zcmOUT.Checked = 'on';
        
        zoomHandle.Direction = 'out';
        
    case 'xy'
        
        handles.uiFramework.zcmXY.Checked = 'on';
        handles.uiFramework.zcmX.Checked = 'off';
        handles.uiFramework.zcmYL.Checked = 'off';
        
        zoomHandle.Motion = 'both';
        
    case 'x'
        
        handles.uiFramework.zcmXY.Checked = 'off';
        handles.uiFramework.zcmX.Checked = 'on';
        handles.uiFramework.zcmYL.Checked = 'off';
        
        zoomHandle.Motion = 'horizontal';
        
    case 'yl'
        
        handles.uiFramework.zcmXY.Checked = 'off';
        handles.uiFramework.zcmX.Checked = 'off';
        handles.uiFramework.zcmYL.Checked = 'on';
        
        zoomHandle.Motion = 'vertical';
        
    case 'yr'
        
end

end

