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

% [file, path] = uigetfile('*.mp4');

vid = VideoReader(fullfile(path, file));
vid2 = vid;%VideoReader(fullfile(path, file2));

duration = vid.Duration

fr = vid.FrameRate

% nf = vid.NumFrames
% 
% nf/fr

nf = duration*fr - 1

% video player figure
fig = figure('Position',[305,467,1622,595.34]);

vBox = uix.VBox('Parent',fig);

pltBox = uix.HBox('Parent', vBox);
axBox = uix.Panel('Parent', pltBox);
ax2Box = uix.Panel('Parent', pltBox);

sldBox = uix.HButtonBox('Parent', vBox);

sldBox.ButtonSize = [400 40];

btnBox = uix.HButtonBox('Parent', vBox);

btnBox.ButtonSize = [50 50];

vBox.Heights = [-1 50 50];

ax = axes(axBox);
axis tight
ax2 = axes(ax2Box);
axis tight

pauseBtn = uicontrol(btnBox, 'Style', 'pushbutton',...
    'CData', imread('icons8-pause-32.png'),...
    'Callback', @pauseCallback);

playBtn = uicontrol(btnBox, 'Style', 'pushbutton',...
    'CData', imread('icons8-play-32.png'),...
    'Callback', @playCallback);

sliderHandle = uicontrol(sldBox, 'Style', 'slider',...
    'Min', 1, 'Max', nf, 'Value', 1,...
    'SliderStep', [1/nf,60/nf], 'Tag', 'sliderMov');

sliderHandle.UserData.mov = vid;
sliderHandle.UserData.mov2 = vid2;
sliderHandle.UserData.ax  = ax;
sliderHandle.UserData.ax2  = ax2;
sliderHandle.UserData.offset = 2.2974364e+04*0;
sliderHandle.UserData.offset = 0;
sliderHandle.UserData.offset2 = 0;

sliderListener = addlistener(sliderHandle, 'ContinuousValueChange', ...
    @sliderCallback);

tim = timer;
tim.ExecutionMode = 'fixedRate';
tim.TasksToExecute = 10;
tim.BusyMode = 'drop';
tim.Period = 0.1;%1/fr;
tim.TimerFcn = @timerCallback;

sliderHandle.UserData.timer = tim;
playBtn.UserData.timer = tim;
pauseBtn.UserData.timer = tim;

% while hasFrame(vid)

f = readFrame(vid);

sliderHandle.UserData.img = imshow(f, 'Parent', ax);

sliderHandle.UserData.timeCode = text(ax, 0.45, 0.1, num2str(vid.CurrentTime,7), 'FontSize', 40, 'Color', 'r', 'Units', 'normalized');


f2 = readFrame(vid2);

sliderHandle.UserData.img2 = imshow(f2, 'Parent', ax2);

sliderHandle.UserData.timeCode2 = text(ax2, 0.45, 0.1, num2str(vid2.CurrentTime,7), 'FontSize', 40, 'Color', 'r', 'Units', 'normalized');



% Need to save video info, not object - it saves absolute path to video
% file... not portable...

videoObj.filename = []; % file, path relative to fds. Where is fds on disk???
videoObj.timeOffset= 0;

% fds.linkedVideo = vid;
%
% kVIS_updateDataSet(hObject, fds, name);

end


function playCallback(obj,~)
obj.UserData.timer.Period = 0.017;
obj.UserData.timer.TasksToExecute = 2000;
obj.UserData.timer.start;
end

function pauseCallback(obj,~)
obj.UserData.timer.stop;
end

function sliderCallback(obj,~)

obj.UserData;
obj.Value;

obj.UserData.offset = (22647.69-120.82)*1;
obj.UserData.offset2 = (22647.69-120.82)*1;

f = read(obj.UserData.mov, round(obj.Value));

obj.UserData.img.CData = f;

obj.UserData.timeCode.String = num2str(obj.UserData.offset + obj.UserData.mov.CurrentTime,7);


f2 = read(obj.UserData.mov2, round(obj.Value)-6.5*60*0);

obj.UserData.img2.CData = f2;

obj.UserData.timeCode2.String = num2str(obj.UserData.offset2 + obj.UserData.mov2.CurrentTime,7);

drawnow limitrate

end

function timerCallback(obj,~)
%tic

oo = findobj(gcf, 'Tag','sliderMov');

if oo.UserData.mov.hasFrame && oo.UserData.mov2.hasFrame
    
    oo.Value = oo.Value + 1;
    
    
    f = readFrame(oo.UserData.mov);
    
    oo.UserData.img.CData = f;
    
    oo.UserData.timeCode.String = num2str(oo.UserData.offset + oo.UserData.mov.CurrentTime,7);
    
    
    f = readFrame(oo.UserData.mov2);
    
    oo.UserData.img2.CData = f;
    
    oo.UserData.timeCode2.String = num2str(oo.UserData.offset2 + oo.UserData.mov2.CurrentTime,7);
    
    
    drawnow limitrate
    
else
    obj.stop;
end

%toc
end