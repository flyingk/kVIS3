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

function [signal, signalMeta] = kVIS_fdsGetCurrentChannel(hObject)
%
% return the data and meta information of the currently selected channel
%
handles=guidata(hObject);
%
% selected data set
%
[ fds, fdsName ] = kVIS_getCurrentFds(hObject);
sigName = handles.uiTabData.channelListbox.String{handles.uiTabData.channelListbox.Value};

% Check if channel came from a search request or data group request
if regexp(sigName, '\d*/\d*/') == 1
    sep = strfind(sigName, '/');
    %
    % data group
    %
    var_idx = str2double(sigName(1:sep(1)-1));
    %
    % data channel
    %
    channel_idx = str2double(sigName((sep(1)+1):(sep(2)-1)));
else
    %
    % data group
    %
    var_idx = handles.uiTabData.groupTree.SelectedNodes.Value;
    %
    % data channel
    %
    channel_idx = handles.uiTabData.channelListbox.Value;
end
%
% signal data as vector
%
signal = fds.fdata{fds.fdataRows.data, var_idx}(:, channel_idx);
%
% signal meta data as strings, vector
%
signalMeta.name      = fds.fdata{fds.fdataRows.varNames, var_idx}{channel_idx};
signalMeta.unit      = fds.fdata{fds.fdataRows.varUnits, var_idx}{channel_idx};
signalMeta.frame     = fds.fdata{fds.fdataRows.varFrames, var_idx}{channel_idx};
signalMeta.dispName  = fds.fdata{fds.fdataRows.varNamesDisp, var_idx}{channel_idx};
signalMeta.dataSet   = fdsName;
signalMeta.dataGroup = fds.fdata{fds.fdataRows.groupLabel, var_idx};
signalMeta.timeVec   = fds.fdata{fds.fdataRows.data, var_idx}(:, 1);
signalMeta.offSet    = fds.timeOffset;
signalMeta.sampleRate= fds.fdataAttributes.sampleRates(var_idx);
end

