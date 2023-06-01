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

function eList = kVIS_trimWPList(EventID, eList)
%
% Deletes one or more events from the event list
%

%
% need to delete later event first
%
EventID = flipud(EventID);

%
% remove entries from list
%
for j = 1:size(EventID,1)
    
    % first event
    if EventID(j) == 1
        
        eList = eList(2:end);
    
    % last event
    elseif EventID(j) == length(eList)
        
        eList = eList(1:end-1);
     
    % in the middle
    else
        
        eList = eList([1:EventID(j)-1, EventID(j)+1:end]);
        
    end
    
end

end