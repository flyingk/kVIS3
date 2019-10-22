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

function [signal, signalMeta] = kVIS_fdsGetChannel(fds, group, channel)

% returns the requested channel from the fds structure
%
%  [data, fieldno, channelno] = fds_get_channel(fds, field, channel)
%
% Matt and Kai 2017

% find the array number
group_found = 0;
groupNo = 1;

while (~group_found)
    % Get field name
    current_field = fds.fdata{fds.fdataRows.groupLabel, groupNo};
    
    % Check for match (case insensitive)
    if (strcmpi(current_field, group))
        % Channel has been found
        group_found = 1;
         
    else
        % Increment counter and try again
        groupNo = groupNo + 1;
        
        % Check for end of array
        if groupNo > size(fds.fdata,2)
            signal = -1;
            signalMeta = -1;
            fprintf('Can''t find group << %s >>\n', group);
            return
        end
        
    end
    
end

% find the channel number
channel_found = 0;
channel_idx=1;

while (~channel_found)
    % Get channel name
    current_channel = fds.fdata{fds.fdataRows.varNames, groupNo}{channel_idx};
    
    % Check for match (case sensitive)
    if (strcmp(strip(current_channel),channel))
        % Channel has been found
        channel_found = 1;
        
    else
        % Increment counter and try again
        channel_idx = channel_idx + 1;
        
        % Check for end of array
        if channel_idx > length(fds.fdata{fds.fdataRows.varNames,groupNo})
            signal = -1;
            signalMeta = -1;
            fprintf('Can''t find channel << %s >> in group << %s >>\n', channel, group);
            return
        end
        
    end
end
%
% signal data
%
signal = fds.fdata{fds.fdataRows.data,groupNo}(:,channel_idx);
%
% signal meta data as strings, vector
%
signalMeta.name      = fds.fdata{fds.fdataRows.varNames, groupNo}{channel_idx};
signalMeta.unit      = fds.fdata{fds.fdataRows.varUnits, groupNo}{channel_idx};
signalMeta.frame     = fds.fdata{fds.fdataRows.varFrames, groupNo}{channel_idx};
signalMeta.dispName  = fds.fdata{fds.fdataRows.varNamesDisp, groupNo}{channel_idx};
signalMeta.dataSet   = [];
signalMeta.dataGroup = fds.fdata{fds.fdataRows.groupLabel, groupNo};
signalMeta.timeVec   = fds.fdata{fds.fdataRows.data, groupNo}(:, 1);
end