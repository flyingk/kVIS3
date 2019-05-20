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

function kVIS_plotPanelSelectFcn(hObject, ~)

handles = guidata(hObject);

%
% previously selected panel
%
sourcePanel = findobj('HighlightColor', 'c');

if ~isempty(sourcePanel) && ~isempty(handles)
    % first plot or nothing selected after delete
    sourcePanel.HighlightColor = handles.preferences.uiBackgroundColour;
    
else
%     %
%     % link request?
%     %
%     if sourcePanel.UserData.linkPending == true
%         % link panels
%         sourcePanel.UserData.linkFrom = hObject;
%         hObject.UserData.linkFrom = sourcePanel;
%         sourcePanel.UserData.linkPending = false;
%         
%         % install listener on timeplot
%         ax = hObject.axesHandle;
%         
%         sourcePanel.UserData.listener = addlistener(ax,'UserData','PostSet',@kVIS_fftUpdate);
%         
%         % indicate link
%         rn = 1;%rand;
%         hObject.BackgroundColor = handles.preferences.uiBackgroundColour + 0.2*rn;
%         sourcePanel.BackgroundColor = handles.preferences.uiBackgroundColour + 0.2*rn;
%         sourcePanel.HighlightColor = handles.preferences.uiBackgroundColour;
%         
%         kVIS_fftUpdate([],[])
%         
%         
%     end
    
end
%
% set selected plot active
%
hObject.HighlightColor = 'c';



end