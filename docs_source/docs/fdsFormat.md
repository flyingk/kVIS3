# FDS file format

The FDS ( Flight Data Structure ) file is a structure containing a cell array with the actual data, and some supporting fields that describe or ease the interpretation of the data:

## List of Fields

### Cell Array `fdata`:

Array holding data and associate information (labels, units, tree state) - Row content of the array defined by the fields of the structure fdataRows. - Each column of the cell array represents a (logical/functional) group of data channels. The composition of each group is defined by the BSP. - All groups must have a common time vector as the first channel, the BSP shall re-sample individual channels of a group to comply with this requirement.

### Struct `fdataRows`:

Relates row number of the fdata cell array with an identifier. This avoids hard-coded addressing for compatibility with older files.

```
struct( ...
    'groupLabel'        , 1, ... group name
    'varNames'          , 2, ... list of channel names
    'varUnits'          , 3, ... list of channel units
    'varFrames'         , 4, ... reference frame of channel
    'varNamesDisp'      , 5, ... display name of variable - the BSP may provide this separate field and it shall take precedence over the 'vars' field entry for generating channel names.
    'tbd'               , 6, ... for future use
    'data'              , 7, ... channel data - group sample time vector as channel 1 (all channels in group have common time vector)
    'treeParent'        , 8, ... group parent in tree
    'treeGroupExpanded' , 9, ... group node expanded
    'treeGroupSelected' ,10  ... group node selected
);
```

### Struct `fdataAttributes`:

Store attributes of fdata for easy access without loading the potentially large cell array. All fields, except nfiles, are arrays of size [nfiles].

```
struct( ...
    'nFiles'    , {}, ... number of data groups in fdata
    'nChnls'    , {}, ... number of channels for each group
    'nPoints'   , {}, ... number of samples for each group
    'sampleRates', {}, ... sample rate for each group
    'startTimes' , {}, ... start time value for each group, relative to the `startTime` field in `testInfo`
    'stopTimes'  , {}  ... stop time value for each group, relative to the `startTime` field in `testInfo`
);
```

### Struct `eventList`:

Store event data

```
struct( ...
     'type'       , {}, ... event type/identifier (potentially non-unique)
     'start'      , {}, ... start time, relative to the `startTime` field in `testInfo`
     'end'        , {}, ... end time, relative to the `startTime` field in `testInfo`
     'description', {}, ... optional description
     'plotDef'    , {}  ... linked custom plot definition provided by the BSP
);
```

### Array `eventTypes`:

List of event types - to be updated by BSP during import

Should provide some generic types and an ‘unspecified’ default type.

eventTypes = {'unspecified', 'armed'};

### Struct `aircaftData`:

Store information about the aircraft (mass, inertias…)

- mass, inertia and CG at take-off. If variable, these need to be provided as data channels
- body axes frame: X forward, Y right, Z down
- may contain BSP specific fields (see Notes)

```
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
```

###Struct `testInfo`:

Store information about the flight test (pilot, weather, location…)

- may contain BSP specific fields (see Notes)

```
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
```


### Struct `ftiSensorProperties`:

Information/location of a sensor

```
ftiSensorProperties = struct( ...
   'identifier',        '', ... Sensor ID
   'type',              '', ... Sensor ID
   'description',       '', ... Sensor ID
   'xCoord',            '', ... Sensor ID
   'yCoord',            '', ... Sensor ID
   'zCoord',            ''  ... Sensor ID
);
```

### Struct `ftiSensors`:

Structure containing one ftiSensorProperties struct for each installed sensor. Filled by BSP.

```
fds.ftiSensors = struct( ...
    'airdata',    ftiSensorProperties, ...
    'gpsAntenna', ftiSensorProperties  ...
);
```

### Other Fields:

- double timeOffset: time axis offset for this dataset (relative to a Master set specified in the App)

- char created[]: time and date of fds struct creation

- char boardSupportPackage[]: identifier of data acquisition system, enables BSP specific functionalities

- float fdsVersion: version of FDS format definition

- char pathOpenedFrom[]: field to save origin path for save function

### Notes

- FDS can contain BSP specific fields, as long as they do not interfere with this specification. No kVIS3 baseline function may require a non standard FDS field. Access to BSP specific fields must only be done through a BSP function.

