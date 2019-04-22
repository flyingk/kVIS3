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

function [ fds ] = kVIS_fdsGenerateTexLabels(fds)

%
% Placeholder to generate TeX Labels if not already specified
%

for i = 1 : fds.fdataAttributes.nFiles
    %
    % skip tree hierachy entries 
    %
    if isempty(fds.fdata{fds.fdataRows.varNames,i})
        continue;
    end
    
    if ~isempty(fds.fdata{fds.fdataRows.varLabelsTeX,i})
        % keep existing
    else
        names = fds.fdata{fds.fdataRows.varNames,i};
        
        fds.fdata{fds.fdataRows.varLabelsTeX,i} = names;
    end
    
end

end

% ans =
%
%   struct with fields:
%
%        RawName: 'V_y_K_cmd_UNIT_m_d_s_FRAME_FP'
%         Symbol: 'V'
%           Axis: 'y'
%           Unit: 'm/s'
%          Frame: 'FP'
%     Subscripts: {'K'  'cmd'}



%     display_name_TeX = [ ...
%         strip(signal.name_TeX), ...
%         strrep(sprintf( ...
%                 ' [$%s$] (%s)', ...
%                 regexprep(signal.unit, '^\s*\((.*)\)\s*$', '$1'), ...
%                 strip(flight_name) ...
%             ), '_', '\_') ....
%     ];
% 
% 
% 
%     display_name = strrep(sprintf( ...
%         '%s [%s] (%s)', ...
%         strip(signal.name), ...
%         regexprep(signal.unit, '^\s*\((.*)\)\s*$', '$1'), ...
%         strip(flight_name) ...
%     ), '_', '\_');