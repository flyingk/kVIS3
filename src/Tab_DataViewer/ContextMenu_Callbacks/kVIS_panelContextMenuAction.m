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

function kVIS_panelContextMenuAction(hObject, ~, panel)

handles = guidata(hObject);

switch hObject.Label
    
    case 'Timeplot'
        
        panel.Tag = 'timeplot';
        panel.linkPending = false;
        panel.linkTo = [];
        panel.linkFrom = [];
        
        % find the checked menu item
        oldM = findobj(hObject.Parent, 'Checked', 'on');
        oldM.Checked = 'off';
        % check on for selection
        hObject.Checked = 'on';
        
    case 'Frequency plot'
        
        kVIS_dataViewerLinkTimeAxes(handles, 'off');
        
        panel.Tag = 'fftplot';
        panel.linkPending = true;
        panel.linkTo = [];
        panel.linkFrom = [];
        
        oldM = findobj(hObject.Parent, 'Checked', 'on');
        oldM.Checked = 'off';
        
        hObject.Checked = 'on';
        
        % this needs more work
        %         kVIS_dataViewerLinkTimeAxes(handles, 'x');
        
    case 'Map plot'
        
        kVIS_dataViewerLinkTimeAxes(handles, 'off');
        
        panel.Tag = 'mapplot';
        panel.linkPending = false;
        panel.linkTo = [];
        panel.linkFrom = [];
        
        oldM = findobj(hObject.Parent, 'Checked', 'on');
        oldM.Checked = 'off';
        
        hObject.Checked = 'on';
        
        kVIS_createMap_Callback(hObject, []);
        
    case 'Correlation plot'
        
        kVIS_dataViewerLinkTimeAxes(handles, 'off');
        
        panel.Tag = 'corrplot';
        panel.linkPending = true;
        panel.linkTo = [];
        panel.linkFrom = [];
        
        oldM = findobj(hObject.Parent, 'Checked', 'on');
        oldM.Checked = 'off';
        
        hObject.Checked = 'on';
        
    case 'Delete panel'
        
        kVIS_dataViewerDelElement(handles, []);
        
end

end

