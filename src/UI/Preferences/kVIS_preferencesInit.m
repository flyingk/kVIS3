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

function kVIS_preferencesInit()
%
% Init preferences to defaults - needs to be done for each separately to be able to add
% new...
%
if ~ispref('kVIS_prefs','bspDir')
    addpref('kVIS_prefs','bspDir','')
end

if ~ispref('kVIS_prefs','uiBackgroundColour')
    addpref('kVIS_prefs','uiBackgroundColour',[0.3,0.4,0.58])
end

if ~ispref('kVIS_prefs','uiPlotWidthFraction')
    addpref('kVIS_prefs','uiPlotWidthFraction', 2.0)
end

if ~ispref('kVIS_prefs','uiDataChannelBoxWidth')
    addpref('kVIS_prefs','uiDataChannelBoxWidth', 150)
end

if ~ispref('kVIS_prefs','defaultGroupTreeFontSize')
    addpref('kVIS_prefs','defaultGroupTreeFontSize',16)
end

if ~ispref('kVIS_prefs','defaultLegendFontSize')
    addpref('kVIS_prefs','defaultLegendFontSize',12)
end

if ~ispref('kVIS_prefs','dataReplayFeature')
    addpref('kVIS_prefs','dataReplayFeature','off')
end

if ~ispref('kVIS_prefs','dataReplayTargetIP')
    addpref('kVIS_prefs','dataReplayTargetIP','127.0.0.1')
end

if ~ispref('kVIS_prefs','google_maps_api_key')
    addpref('kVIS_prefs','google_maps_api_key','')
end

% prefs = getpref('kVIS_prefs')
end

%% todo:
% Preferences data structure:
% 
% Value
% Value data type
% Restart flag
% Update fcn handle