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

function fds = kVIS_eventTimeSeries(hObject, fds)
%
% create a timeseries indicating event locations
%
[dataRange] = kVIS_fdsGetGlobalDataRange(hObject);

timeVec = dataRange(1) : 0.01 : dataRange(2);

eventVec = zeros(length(timeVec), 1);


eventList = fds.eventList;


for j = 1:size(eventList,2)
    
    % relate times to samples
    in = find(timeVec >= eventList(j).start, 1, 'first')+1;
    out= find(timeVec <= eventList(j).end, 1, 'last');
    
    % create event channel
    eventVec(in : out) = 1;

end
    
data = [timeVec' eventVec];
varNames = {'Time'; 'Events'};
varUnits = {'sec'; '-'};   
varFrames = {''; ''};  

% check if node exists already
[~, nodeIndex] = kVIS_fdsGetGroup(fds, 'Event_Index');

if nodeIndex > 0
    % update tree node
    [ fds ] = kVIS_fdsReplaceTreeLeaf(fds, 'Event_Index', varNames, varNames, varUnits, varFrames, data, false);
else
    % add tree node
    fds = kVIS_fdsAddTreeLeaf(fds, 'Event_Index', varNames, varNames, varUnits, varFrames, data, 0, false);
end

end