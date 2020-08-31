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

%*************************************************************************%
% Project Name : kVIS
% Author       : Antonio Hortal <antonio.hortal@lilium.com>
% Name         : kVIS_dataViewerExportAllPlots.m
% Description  : Export a kVIS panel into a subplot
%
% Copyright Lilium GmbH 2020
%*************************************************************************%

function kVIS_dataViewerExportAllPlots(hObject, ~)

kvis = findobj('Tag', 'appWindow');

% KVIS uses the GUI Layout toolbox, a set of tools that organizes the
% different GUI elements in boxes where more boxes/elements can be added.
% We need to look into those elements (see the /+uix package) and find
% where are our axes located

% 1. Our data to be extracted are the axes and their plots. If we look at
% kVIS, all axes are located inside a tab called 'Data Viewer'. First step,
% find the data viewer tab
kchild = kvis.Children;                              % Get the kVIS children
uixidx = arrayfun(@(x) isa(x, 'uix.VBox'), kchild);  % Find the uix element (normally idx 7)
uixbox = kchild(uixidx);                             % Get the uix element
flxidx = arrayfun(@(x) isa(x, 'uix.HBoxFlex'), uixbox.Children); % The data viewer is resizable, so we need to find a 'BoxFlex' component
flxbox = uixbox.Children(flxidx);                    % Get the resizable box element
tabidx = arrayfun(@(x) isa(x, 'matlab.ui.container.TabGroup'), flxbox.Children);
tabgrp = flxbox.Children(tabidx);                    % Get the tabgroup element
tabs          = tabgrp.Children;                     % FInd the datat viewer between the tabs
tabttl        = {tabs.Title};
dataViewerIdx = strcmp(tabttl, 'Data Viewer');
dataViewer    = tabs(dataViewerIdx);

% 2. The data viewer has a resizable horizontal box container that serves
% as basis. 
dvwrbox = dataViewer.Children(1);

% 3. Then, every added column creates a resizable vertical box container.
% Note that columns are added in the reverse order (from right to left)
columns = dvwrbox.Children;
ncols   = length(columns);
axCell  = cell(1, ncols); % We will also initialize the container of the graphical objects

% 4. We will now iterate through the columns to find the rows inside each 
% column. And inside the rows we will find the panels that contain the
% axes, and we will store those in the preinitialized cells
maxrows = 0;
for ii = ncols:-1:1
    rows               = columns(ii).Children;
    nrows              = length(rows);
    maxrows            = max(maxrows, nrows);
    axCell{ncols-ii+1} = gobjects(nrows, 1);
    for jj = nrows:-1:1 % Rows are also in reverse order (from bottom to top)
        ax = rows(jj).Children(arrayfun(@(x) isa(x, 'matlab.graphics.axis.Axes'),rows(jj).Children));
        axCell{ncols-ii+1}(nrows-jj+1) = ax;
    end
end
 
% 5. Exporting begins here. Create the figure, and define the subplot
% structure using the information inside 'axCell'
% Check for weird structures
for kk = 1:ncols
    if mod(length(axCell{kk}),maxrows)
        maxrows = maxrows * length(axCell{kk});
    end
end

hfig = figure();
for ii = 1:ncols
    axrows = axCell{ii};
    nax    = length(axrows);
    step   = maxrows/nax;
    for jj = 1:nax
        a = copyobj(axCell{ii}(jj), hfig);
        init = ii + (jj-1)*step*ncols;
        fin  = init + (step-1)*ncols;
        aa = subplot(maxrows, ncols, init:ncols:fin, changeAxes(a));
        changeLegend(aa);
    end
end


m = uimenu(hfig,'Text','kVIS3');
uimenu(m, 'Text', 'Print Figure', 'Callback', @printcallback)
end

function a = changeAxes(a)
a.XLabel.Color = [0 0 0];
a.YLabel.Color = [0 0 0];
a.XColor       = [0 0 0];
a.YColor       = [0 0 0]; 
a.XLabel.FontSize = 12;
a.YLabel.FontSize = 12;
end

function changeLegend(a)
l  = legend(a);
l.Interpreter = 'latex';
l.FontSize    = 12;
end

function printcallback(h,e)

if ismac
    [f,p]=uiputfile('kVIS plot.jpg',[],'~/Desktop/kVIS plot.jpg');
    
    if f ~= 0
        fileN = fullfile(p,f);
        print(gcf,'-noui',fileN,'-djpeg','-r200')
    end
    
elseif ispc
    [f,p]=uiputfile('kVIS plot.jpg',[],['C:\Users\' getenv('Username') '\Desktop\kVIS plot.jpg']);
    
    if f ~= 0
        fileN = fullfile(p,f);
        print(gcf,'-noui',fileN,'-djpeg','-r200')
    end

end

end



































