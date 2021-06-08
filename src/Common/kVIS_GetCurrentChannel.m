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

function [signal, signalMeta] = kVIS_GetCurrentChannel(hObject)
%
% return the data and meta information of the currently selected channel
%
handles=guidata(hObject);
%
% selected data set
%
[ fds, fdsName ] = kVIS_getCurrentFds(hObject);
%
% selected channel
%
sigName = handles.uiTabData.channelListbox.String{handles.uiTabData.channelListbox.Value};
%
% Check if channel came from a search request or data group request
%
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
    
    
    % open tree at corresponding location
    str = strsplit(sigName,'/');
    
    % open tree group
    kVIS_fdsUpdateSelectionInfo(hObject, str2double(str{1}))
    
    % why get fds again?? It breaks if not...
    fds = kVIS_getCurrentFds(hObject);
    
    kVIS_groupTreeUpdate(hObject, fds, 'search')
    
    
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
% Retrieve channel data
%
[signal, signalMeta] = kVIS_fdsGetChannel(fds, var_idx, channel_idx);

signalMeta.dataSet   = fdsName;

end


