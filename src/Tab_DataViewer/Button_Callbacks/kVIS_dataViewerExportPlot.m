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

handles=guidata(hObject);

l = findobj('Tag', 'plotPanel_active');
ax_r = findobj(l,'Type','axes');

limx=get(ax_r,'Xlim');
scalex=get(ax_r,'XScale');
scaley=get(ax_r,'YScale');
labelx=get(ax_r,'Xlabel');
labely=get(ax_r,'Ylabel');

f2=figure;
set(f2,'Color','w');
ax2=axes('Parent',f2);
copyobj(allchild(ax_r), ax2);
set(ax2,'XLim',limx)
set(ax2,'XScale',scalex)
set(ax2,'YScale',scaley)
set(ax2,'Xlabel',labelx)
set(ax2,'Ylabel',labely)
grid(ax2, 'on')
end

