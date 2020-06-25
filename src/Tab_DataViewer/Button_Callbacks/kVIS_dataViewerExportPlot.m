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

function kVIS_dataViewerExportPlot(hObject, ~)

answ = questdlg('What to export: ','What to export?','Selected Plot','All Plots','Cancel','Selected Plot');

if strcmp(answ,'Cancel')
    return
elseif strcmp(answ,'All Plots')
    kVIS_dataViewerExportAllPlots(hObject,[]);
    return
end

l = kVIS_dataViewerGetActivePanel();

if ~isempty(l.linkTo)
    
    f3=figure;
    set(f3,'Color','w');
    
    
    h = copyobj(allchild(l.linkTo), f3);
    
    ax = findobj(h, 'Type', 'axes');
    
    ax.XColor = 'k';
    ax.YColor = 'k';
    
    ax.Parent.Tag = l.linkTo.Tag;
    
    kVIS_axesResizeToContainer(ax);
    
    f3p = f3.Position;
    
    movegui(f3, f3p(1:2) + [-100 0])
    
end

f2=figure;
set(f2,'Color','w');


h = copyobj(allchild(l), f2);

ax = findobj(h, 'Type', 'axes');

ax.XColor = 'k';
ax.YColor = 'k';

% for map plot
ax.Title.Color = 'k';

ax.Parent.Tag = l.Tag;

kVIS_axesResizeToContainer(ax)
end

