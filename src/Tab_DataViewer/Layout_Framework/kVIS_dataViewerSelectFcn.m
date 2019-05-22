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

function kVIS_dataViewerSelectFcn(selectedPanel, ~)
% scenarios
% - no previous selection: make current panel active
% - previous selection exists:
%   - no link request: make current panel active, previous panel inactive
%   - link request: link panels, make target active

handles = guidata(selectedPanel);

%
% get previously selected panel
%
previousPanel = kVIS_dataViewerGetActivePanel;

if isempty(previousPanel)
    %
    % first plot or nothing selected after delete
    %
    selectedPanel.HighlightColor = 'c';
    
elseif previousPanel == selectedPanel
    %
    % callback goes all the time...
    %
    return
    
elseif ~strcmp(selectedPanel.Tag, 'timeplot')
    %
    % don't select special plots
    %
    return
    
else
    %
    % link request?
    %
    if previousPanel.linkPending == true
        % link panels
        previousPanel.linkFrom = selectedPanel;
        selectedPanel.linkTo = previousPanel;
        previousPanel.linkPending = false;
        
        % install listener on linked timeplot
        % save listener handle in link target
        previousPanel.plotChangedListener = addlistener(selectedPanel,...
            'plotChanged','PostSet',@kVIS_fftUpdate);
        
        % indicate link
        rn = 1;%rand;
        selectedPanel.BackgroundColor = handles.preferences.uiBackgroundColour + 0.2*rn;
        previousPanel.BackgroundColor = handles.preferences.uiBackgroundColour + 0.2*rn;
        
        previousPanel.HighlightColor = handles.preferences.uiBackgroundColour;
        selectedPanel.HighlightColor = 'c';
        
        kVIS_fftUpdate([],[])
        
    else
        %
        % set selected panel active, previous panel inactive
        %
        selectedPanel.HighlightColor = 'c';
        
        previousPanel.HighlightColor = handles.preferences.uiBackgroundColour;
        
    end
    
end


end