%
%> @file kVIS_fdsImportVideo.m
%> @brief Import a video file to be linked to the test data WiP
%
%
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

%
%> @brief Import a video file to be linked to the test data WiP
%>
%> @param App handles
%> @param App events
%>
%
function kVIS_fdsImportVideo(hObject, ~)

clc

[fds, name] = kVIS_getCurrentFds(hObject);

[file, path] = uigetfile('*.mp4');

vid = VideoReader(fullfile(path, file));


% video player figure
fig = figure();

ax = axes(fig);

uicontrol(fig, 'Style', 'pushbutton',...
    'CData', imread('icons8-pause-32.png'),...
    'Position',[100 100 50 50]);


while hasFrame(vid)
    
    f = readFrame(vid);
    
    imshow(f, 'Parent', ax, 'Border','tight')
    
    timeCode = text(ax, 0.45, 0.1, num2str(vid.CurrentTime), 'FontSize', 40, 'Color', 'r', 'Units', 'normalized');
    
    pause(1/vid.FrameRate);
    
end


% Need to save video info, not object - it saves absolute path to video
% file... not portable...

videoObj.filename = []; % file, path relative to fds. Where is fds on disk???
videoObj.timeOffset= 0;

% fds.linkedVideo = vid;
% 
% kVIS_updateDataSet(hObject, fds, name);

end

