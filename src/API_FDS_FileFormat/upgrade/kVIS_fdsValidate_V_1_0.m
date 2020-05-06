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

function kVIS_fdsValidate_V_1_0(fds)
    % Validate a given FDS against the specification V 1.0
    % Throws an error if invalid.

    assert(isstruct(fds), 'FDS must be a struct');

    assert(isfield(fds, 'fdsVersion'), 'fds.Version: missing');

    assert(isfield(fds, 'created'), 'fds.created: missing');
    try
        datetime(fds.created);
    catch
        error('fds.created: invalid value: %s', fds.created);
    end

    assert(isfield(fds, 'fdataRows'), 'fds.fdataRows: missing');
    assert(isstruct(fds.fdataRows), 'fds.fdataRows: invalid type, must be struct');
    fields = {
        'groupLabel'
        'varNames'
        'varUnits'
        'varFrames'
        'varNamesDisp'
        'data'
        'treeParent'
        'treeGroupExpanded'
        'treeGroupSelected'
    };
    % only check for missing fields, ignore additional fields
    missingFields = setdiff(fields, fieldnames(fds.fdataRows));
    assert(isempty(missingFields), 'fds.fdataRows: missing fields: %s', strjoin(missingFields, ', '));
    rowIdx = cellfun(@(x) fds.fdataRows.(x), fields);
    assert((numel(fields) == numel(unique(rowIdx))), 'fds.fdataRows: values must be unique');

    assert(isfield(fds, 'fdataAttributes'), 'fdataAttributes: missing');
    assert(isstruct(fds.fdataAttributes), 'fds.fdataAttributes: invalid type, must be struct');
    fields = {
        'nFiles'
        'nChnls'
        'nPoints'
        'sampleRates'
        'startTimes'
        'stopTimes'
    };
    missingFields = setdiff(fields, fieldnames(fds.fdataAttributes));
    assert(isempty(missingFields), 'fds.fdataAttributes: missing fields: %s', strjoin(missingFields, ', '));

    assert(isfield(fds, 'eventList'), 'fds.eventList: missing');
    % TODO: validate eventList
    assert(isfield(fds, 'eventTypes'), 'fds.eventTypes: missing');
    % TODO: validate eventTypes

    assert(isfield(fds, 'aircraftData'), 'fds.aircraftData: missing');
    assert(isstruct(fds.aircraftData), 'fds.aircraftData: invalid type, must be struct');
    fields = {
        'acIdentifier'
        'sRef_UNIT_none'
        'cRef_UNIT_none'
        'bRef_UNIT_none'
        'mass_UNIT_kg'
        'ixx_UNIT_kgm2'
        'iyy_UNIT_kgm2'
        'izz_UNIT_kgm2'
        'ixz_UNIT_kgm2'
        'xCG_UNIT_m'
        'yCG_UNIT_m'
        'zCG_UNIT_m'
    };
    missingFields = setdiff(fields, fieldnames(fds.aircraftData));
    assert(isempty(missingFields), 'fds.aircraftData: missing fields: %s', strjoin(missingFields, ', '));
    % TODO: validate individual aircraftData fields

    assert(isfield(fds, 'testInfo'), 'fds.testInfo: missing');
    assert(isstruct(fds.testInfo), 'fds.testInfo: invalid type, must be struct');
    fields = {
       'date'
       'startTime'
       'description'
       'pilot'
       'location'
       'weather'
       'windDir_UNIT_deg'
       'windSpeed_UNIT_m_d_s'
       'ambientPressure_UNIT_Pa'
       'ambientTemperature_UNIT_C'
       'gravity_UNIT_m_d_s2'
    };
    missingFields = setdiff(fields, fieldnames(fds.testInfo));
    assert(isempty(missingFields), 'fds.testInfo: missing fields: %s', strjoin(missingFields, ', '));
    % TODO: validate individual testInfo fields

    assert(isfield(fds, 'BoardSupportPackage'), 'fds.BoardSupportPackage: missing');

end
