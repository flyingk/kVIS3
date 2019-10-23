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

function fds = kVIS_fdsUpdateAttributes(fds)

% number of data groups
fds.fdataAttributes.nFiles = size(fds.fdata, 2);
% number of channels per group
fds.fdataAttributes.nChnls  = cellfun(@(x) size(x, 2), fds.fdata(fds.fdataRows.data, :));
% number of samples per group
fds.fdataAttributes.nPoints = cellfun(@(x) length(x), fds.fdata(fds.fdataRows.data, :));
% sample rate per group - calc or specify???
fds.fdataAttributes.sampleRates = sampleRate(fds.fdata(fds.fdataRows.data, :));
% start time per group
fds.fdataAttributes.startTimes = startTime(fds.fdata(fds.fdataRows.data, :));
% stop time per group
fds.fdataAttributes.stopTimes = stopTime(fds.fdata(fds.fdataRows.data, :));
end


function x = sampleRate(in)

x =[];

for i = 1:length(in)
    
    if ~isempty(in{i})
        
        dt = diff(in{i}(:,1));
        
        x = [x 1/mean(dt)];
        
    else
        
        x = [x -1];
    end
    
end

end


function x = startTime(in)

x =[];

for i = 1:length(in)
    
    if ~isempty(in{i})
        
        x = [x in{i}(1,1)];
        
    else
        
        x = [x NaN];
    end
    
end

end


function x = stopTime(in)

x =[];

for i = 1:length(in)
    
    if ~isempty(in{i})
        
        x = [x in{i}(end,1)];
        
    else
        
        x = [x NaN];
    end
    
end

end