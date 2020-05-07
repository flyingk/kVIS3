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

DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'k';
DefaultStyle.Axes.YColor = 'k';
DefaultStyle.Axes.GridColor = 'k';
DefaultStyle.Axes.MinorGridColor = 'k';

DefaultStyle.Legend.FontSize = 10;
DefaultStyle.Legend.Location = 'Best';
DefaultStyle.Legend.Orientation = 'horizontal';
DefaultStyle.Legend.Interpreter = 'latex';

findobj(gcbf());

    pHandles = findobj(gcbf(), 'Type', 'uipanel');
    
    if ~isempty(pHandles)
 
        for i=1:length(pHandles)
            pHandles(i).BackgroundColor = 'w';
        end

    end
    
    axHandles = findobj(gcbf(), 'Type', 'axes');
    
    if ~isempty(axHandles)
 
        for i=1:length(axHandles)
            kVIS_setGraphicsStyle(axHandles(i), DefaultStyle.Axes);
            kVIS_setGraphicsStyle(axHandles(i), DefaultStyle.Axes);
        end

    end

end
