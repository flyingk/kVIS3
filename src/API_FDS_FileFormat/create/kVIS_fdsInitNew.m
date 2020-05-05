%
%> @file kVIS_fdsInitNew.m
%> @brief Create a new FDS structure as per specification V 1.0 for BSP 'generic'
%
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
%> @brief Create a new FDS structure as per specification V 1.0 for BSP 'generic'
%>
%>
%> @retval New fds structure
%
function fds = kVIS_fdsInitNew()

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
    'tbd'               , 6, ... currently unused
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
   'acIdentifier',   '', ... aircraft name/identifier
   'sRef_UNIT_none', '', ... Full aircraft coefficient reference area
   'cRef_UNIT_none', '', ... Full aircraft moment coefficient reference chord length
   'bRef_UNIT_none', '', ... Full aircraft moment coefficient reference span
   'mass_UNIT_kg',   '', ... Take off mass
   'ixx_UNIT_kgm2',  '', ... Take off Inertia around X body axis
   'iyy_UNIT_kgm2',  '', ... Take off Inertia around Y body axis
   'izz_UNIT_kgm2',  '', ... Take off Inertia around Z body axis
   'ixz_UNIT_kgm2',  '', ... Take off Inertia around XZ body axis
   'xCG_UNIT_m',     '', ... Take off CG location along X body axis
   'yCG_UNIT_m',     '', ... Take off CG location along Y body axis
   'zCG_UNIT_m',     ''  ... Take off CG location along Z body axis
);

fds.testInfo = struct( ...
   'date',                     '', ... Test date
   'startTime',                '', ... UTC time of test start
   'description',              '', ... Short description of data content
   'pilot',                    '', ... Pilot name
   'location',                 '', ... Airfield designation
   'airfieldElevation_UNIT_m', '', ... Airfield elevation above MSL [m]
   'weather',                  '', ... Local weather description string
   'windDir_UNIT_deg',         '', ... Wind direction [deg]
   'windSpeed_UNIT_m_d_s',     '', ... Wind speed [m/s]
   'ambientPressure_UNIT_Pa',  '', ... Local ambient pressure [Pa]
   'ambientTemperature_UNIT_C','', ... Local ambient temperature [C]
   'gravity_UNIT_m_d_s2',      '', ... gravitational acceleration [m/s2]
   'magRef_N_UNIT_Gauss',      '', ... magnetic reference vector N component [Gauss]
   'magRef_E_UNIT_Gauss',      '', ... magnetic reference vector E component [Gauss]
   'magRef_D_UNIT_Gauss',      ''  ... magnetic reference vector D component [Gauss]
);

ftiSensorProperties = struct( ...
   'identifier',        '', ... Sensor ID
   'type',              '', ... Sensor ID
   'description',       '', ... Sensor ID
   'xCoord',            '', ... Sensor ID
   'yCoord',            '', ... Sensor ID
   'zCoord',            ''  ... Sensor ID
);

fds.ftiSensors = struct( ...
    'airdata',    ftiSensorProperties, ...
    'gpsAntenna', ftiSensorProperties  ...
);

fds.BoardSupportPackage = 'generic';

fds.timeOffset = 0;


