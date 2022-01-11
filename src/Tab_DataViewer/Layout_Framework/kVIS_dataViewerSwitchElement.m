%
%> @file kVIS_dataViewerSwitchElement.m
%> @brief Switch active panel
%
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

%
%> @brief Switch active panel
%>
%> @param Panel handle
%
function kVIS_dataViewerSwitchElement(selectedPanel, ~)
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
    
elseif strcmp(selectedPanel.Tag, 'fftplot') || strcmp(selectedPanel.Tag, 'corrplot')
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
        
        % indicate link
        rn = 1;%rand;
        selectedPanel.BackgroundColor = getpref('kVIS_prefs','uiBackgroundColour') + 0.2*rn;
        previousPanel.BackgroundColor = getpref('kVIS_prefs','uiBackgroundColour') + 0.2*rn;
        
        previousPanel.HighlightColor = getpref('kVIS_prefs','uiBackgroundColour');
        selectedPanel.HighlightColor = 'c';
        
        % install listener on linked timeplot
        if strcmp(previousPanel.Tag, 'fftplot')
            % save listener handle in link target
            previousPanel.plotChangedListener = addlistener(selectedPanel,...
                'plotChanged','PostSet',@kVIS_fftUpdate);
            
            kVIS_fftUpdate([],[])
            
        elseif strcmp(previousPanel.Tag, 'corrplot')
            
            previousPanel.plotChangedListener = addlistener(selectedPanel,...
                'plotChanged','PostSet',@kVIS_correlationPlot);
            
            kVIS_correlationPlot([],[])
            
        end
        
    else
        %
        % save limits
        %
        previousPanel.xLim = kVIS_getDataRange(selectedPanel, 'XLim');
        previousPanel.yLim = kVIS_getDataRange(selectedPanel, 'YLim');
        %
        % set selected panel active, previous panel inactive
        %
        selectedPanel.HighlightColor = 'c';
        
        previousPanel.HighlightColor = getpref('kVIS_prefs','uiBackgroundColour');
        
%         kVIS_setDataRange(selectedPanel, 'XLim', selectedPanel.xLim);
        kVIS_setDataRange(selectedPanel, 'YLim', selectedPanel.yLim);
    end
    
end


end