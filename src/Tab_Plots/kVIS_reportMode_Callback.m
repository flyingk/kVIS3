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

function kVIS_reportMode_Callback(hObject, ~)

clc

DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'k';
DefaultStyle.Axes.YColor = 'k';
DefaultStyle.Axes.GridColor = 'k';
DefaultStyle.Axes.MinorGridColor = 'k';

DefaultStyle.Legend.FontSize = 10;
DefaultStyle.Legend.Location = 'Best';
DefaultStyle.Legend.Orientation = 'horizontal';
DefaultStyle.Legend.Interpreter = 'latex';



fs = gcbf();

f3=figure('Visible','off');
f3.Units = 'normalized';
f3.Position = fs.Position;

f3.Units = 'pixels';


obj = findobj(gcbf(), 'Tag', 'plts');


hh = copyobj(obj(1), f3);


hh.Position = [ 1 1 hh.Position(3) hh.Position(4)];
f3.Position = [f3.Position(1)+200 f3.Position(2)+200 hh.Position(3) hh.Position(4)-hh.Position(2)];



pHandles = findobj(f3, 'Type', 'uipanel');

if ~isempty(pHandles)
    
    for i=1:length(pHandles)
        pHandles(i).BackgroundColor = 'w';
    end
    
end

axHandles = findobj(f3, 'Type', 'axes');

if ~isempty(axHandles)
    
    for i=1:length(axHandles)
        kVIS_setGraphicsStyle(axHandles(i), DefaultStyle.Axes);
    end
    
end

axHandles = findobj(f3, 'Type', 'legend');

if ~isempty(axHandles)
    
    for i=1:length(axHandles)
        kVIS_setGraphicsStyle(axHandles(i), DefaultStyle.Legend);
    end
    
end



if ismac
    [f,p]=uiputfile('kVIS plot.jpg',[],'~/Desktop/kVIS plot.jpg');
    
    if f ~= 0
        fileN = fullfile(p,f);
        print(f3,'-noui',fileN,'-djpeg','-r200')
        msgbox('Print complete.')
    end
    
elseif ispc
    [f,p]=uiputfile('kVIS plot.jpg',[],['C:\Users\' getenv('Username') '\Desktop\kVIS plot.jpg']);
    
    if f ~= 0
        fileN = fullfile(p,f);
        print(f3,'-noui',fileN,'-djpeg','-r200')
        msgbox('Print complete.')
    end

end

delete(f3)



end
