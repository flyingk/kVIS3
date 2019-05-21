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

switch hObject.Label
    
    case 'Timeplot'
        
        panel.Tag = 'timeplot';
        panel.UserData.axesHandle.Tag = 'timeplot';
        panel.UserData.linkPending = false;
        panel.UserData.linkTo = [];
        panel.UserData.linkFrom = [];
        
    case 'Frequency plot'
        
        panel.Tag = 'fftplot';
        panel.UserData.axesHandle.Tag = 'fftplot';
        panel.UserData.linkPending = true;
        panel.UserData.linkTo = [];
        panel.UserData.linkFrom = [];
        
        oldM = findobj(hObject.Parent, 'Checked', 'on');
        oldM.Checked = 'off';
        
        hObject.Checked = 'on';
        
    case 'Delete plot'
        
        handles = guidata(hObject);
        
        % last plot in column
        if size(handles.uiTabDataViewer.Divider(panel.UserData.Column).Contents,1) == 1
            if panel.UserData.Column > 1
                delete(handles.uiTabDataViewer.Divider(panel.UserData.Column))
            else
                errordlg('Can''t delete last plot in first column.')
                return
            end
        else
            delete(panel)
        end
        
end

end

