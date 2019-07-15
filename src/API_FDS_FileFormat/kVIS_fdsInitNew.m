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

function fds = kVIS_fdsInitNew()
%
% Create a new FDS structure as per specification V 1.0 for BSP 'generic'
%

fds = struct;


fds.fdsVersion = 1.0;

fds.created = datestr(now);


fds.fdata = cell(10,1); % number of rows according to fdataRows

fds.fdataRows = struct( ...
    'groupLabel'        , 1, ... group name
    'varNames'          , 2, ... list of channel names
    'varUnits'          , 3, ... list of channel units
    'varFrames'         , 4, ... reference frame of channel
    'varNamesDisp'      , 5, ... display name of variable - the BSP may provide this separate field and it shall take precedence over the 'vars' field entry for generating channel names.
    'varLabelsTeX'      , 6, ... assembled TeX version channel label ([Label (or 'varNamesDisp', if available) Unit Frame])
    'data'              , 7, ... channel data - group sample time vector as channel 1 (all channels in group have common time vector)
    'treeParent'        , 8, ... group parent in tree
    'treeGroupExpanded' , 9, ... group node expanded
    'treeGroupSelected' ,10  ... group node selected
);

fds.fdataAttributes = struct( ...
    'nFiles'    , '', ... number of data groups in fdata
    'nChnls'    , '', ... number of channels for each group
    'nPoints'   , '', ... number of samples for each group
    'sampleRates', '', ... sample rate for each group
    'startTimes' , '', ... start time value for each group, relative to the `startTime` field in `testInfo`
    'stopTimes'  , ''  ... stop time value for each group, relative to the `startTime` field in `testInfo`
);


[fds.eventList, fds.eventTypes] = kVIS_fdsCreateEmptyEventList();

fds.aircraftData = struct( ...
   'acIdentifier', '', ... aircraft name/identifier
   'sRef', '', ... Full aircraft coefficient reference area
   'cRef', '', ... Full aircraft moment coefficient reference chord length
   'bRef', '', ... Full aircraft moment coefficient reference span
   'mass', '', ... Take off mass
   'ixx',  '', ... Take off Inertia around X body axis
   'iyy',  '', ... Take off Inertia around Y body axis
   'izz',  '', ... Take off Inertia around Z body axis
   'ixz',  '', ... Take off Inertia around XZ body axis
   'xCG',  '', ... Take off CG location along X body axis
   'yCG',  '', ... Take off CG location along Y body axis
   'zCG',  ''  ... Take off CG location along Z body axis
);

fds.testInfo = struct( ...
   'date',              '', ... Test date
   'startTime',         '', ... UTC time of test start
   'description',       '', ... Short description of data content
   'pilot',             '', ... Pilot name
   'location',          '', ... Airfield designation
   'airfieldElevation', '', ... Airfield elevation above MSL [m]
   'weather',           '', ... Local weather description string
   'windDir',           '', ... Wind direction [deg]
   'windSpeed',         '', ... Wind speed [m/s]
   'ambientPressure',   '', ... Local ambient pressure [Pa]
   'ambientTemperature','', ... Local ambient temperature [C]
   'gravity',           '', ... gravitational acceleration [m/s2]
   'magRef_N',          '', ... magnetic reference vector N component [Gauss]
   'magRef_E',          '', ... magnetic reference vector E component [Gauss]
   'magRef_D',          ''  ... magnetic reference vector D component [Gauss]
);

fds.BoardSupportPackage = 'generic';

fds.timeOffset = 0;


