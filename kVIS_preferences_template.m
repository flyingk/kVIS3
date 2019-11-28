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

function [kVIS_prefs] = kVIS_preferences_template()
% kVIS Preferences Template
%
% Rename to kVIS_preferences.m and save so it will be used. Add the
% paths to the BSP (mandatory).
%
% kVIS_preferences.m itself is not tracked by GIT, since it may contain
% sensitive information not intended to be publicly available.

%% External Board Support Packages (BSPs)
kVIS_prefs.bsp_dir = '';

%% Google Maps API Key
kVIS_prefs.google_maps_api_key = '';

%% UI Colours
kVIS_prefs.uiBackgroundColour  = [0.3,0.4,0.58];
kVIS_prefs.uiForegroundColour1 = 'w';
kVIS_prefs.uiForegroundColour2 = 'y';

kVIS_prefs.fdsCurrentVersion = 1.0;

kVIS_prefs.defaultGroupTreeFontSize = 6;
kVIS_prefs.defaultLegendFontSize = 12;

kVIS_prefs.dataReplayFeature = 'on'; % on/off
kVIS_prefs.dataReplayTargetIP = '127.0.0.1';