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

function [ labelStr ] = kVIS_generateLabels(signalMeta, stringModifier)
%
% Generate the labelstring for signal metadata and an optional modifier
% in Latex format for use in plot labels and legends
%

%
% Option 1: Information is provided as single string in NAME fields as per
% naming convention.
%
% Option 2: Name components are provided in separate fields - assemble into
% name string as per naming convention
%
% Option 3: String provided is a LaTeX string already
%

if ~isstruct(signalMeta)

    if ~ischar(signalMeta)
        labelStr = '';
        return
    end

    % name string already provided (option 3)
    if startsWith(strip(signalMeta), '$')
        labelStr = strip(signalMeta);
        return
    else
        NameStr = strip(signalMeta);
    end
    
else
    
    % option 1/2
    NameStr = strip(signalMeta.name);
    
    % check which option applies
    if ~contains(NameStr, 'UNIT')
        
        % option 2 - assemble string
        if ~isempty(signalMeta.unit)
            NameStr = [NameStr '_UNIT_' strip(signalMeta.unit)];
        end
        
        if ~isempty(signalMeta.frame)
            NameStr = [NameStr '_FRAME_' strip(signalMeta.frame)];
        end
        
    end
    
end

%
% Process name string
%
[ SignalInfo ] = kVIS_extractInfoFromSignalName( NameStr );

%
% Assemble output
%
if isempty(SignalInfo.TeX_Unit)
    labelStr = SignalInfo.TeX_Name;
else
    labelStr = [SignalInfo.TeX_Name ' ' SignalInfo.TeX_Unit];
end