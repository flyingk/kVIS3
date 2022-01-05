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

function kVIS_reportModeFigFormat_Callback(hObject, ~)

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

%% PR 115-1897 quick fix
% Something in the existing plot will not load correctly when saved as a
% .fig file.
% in order to work around this, the subplots will be copied from the
% existing plot to a new plot before saving.

f_new = figure('visible','off');
gcf;
f_new.Name = fs.Name;
w = length(f3.Children.Children);
h_max = 0;
for c=1:w
    if length(f3.Children.Children(c,1).Children) > h_max
        h_max = length(f3.Children.Children(c,1).Children);
    end
end

%% 
% The current figure subplot positions increase in rows from bottom to top
% and columns from right to left. Therefore, we must iterate through them
% in reverse order to maintain the same positions in the new plot.

n_spp = 1;
spp = 1;
for r = h_max:-1:1
    for c = w:-1:1
        if length(f3.Children.Children(c,1).Children) < r
            continue
        end
        if isa(f3.Children.Children(c,1).Children(r,1).Children, 'matlab.graphics.axis.Axes')
            if length(f3.Children.Children(c,1).Children(r,1).Children.Children) > 0
                % ensure we dont copy an empty axes
                sp = copyobj(f3.Children.Children(c,1).Children(r,1).Children,...
                    f_new);
                sp_ax(n_spp, 1) = sp;
                subplot(h_max, w, spp, sp_ax(n_spp, 1));
                n_spp = n_spp + 1;
            end    
        elseif length(f3.Children.Children(c,1).Children(r,1).Children) == 2
            sp = copyobj([f3.Children.Children(c,1).Children(r,1).Children(2,1),...
                f3.Children.Children(c,1).Children(r,1).Children(1,1)], f_new);
            sp(2).Orientation = 'vertical';
            sp(2).Location = 'westoutside';
            sp_ax(n_spp, 1) = sp(1);
            subplot(h_max, w, spp, sp_ax(n_spp, 1));
            n_spp = n_spp + 1;
        end
        spp = spp + 1;
    end
end

linkaxes(sp_ax, 'x');
 
%% 

if ismac
    [f,p]=uiputfile('kVIS plot.fig',[],'~/Desktop/kVIS plot.fig');
    
    if f ~= 0
        fileN = fullfile(p,f);
        set(f_new, 'visible', 'on');
        savefig(f_new, fileN);
        kVIS_terminalMsg('Print complete.')
    end
    
elseif ispc
    [f,p]=uiputfile('kVIS plot.fig',[],['C:\Users\' getenv('Username') '\Desktop\kVIS plot.fig']);
    
    if f ~= 0
        fileN = fullfile(p,f);
        set(f_new, 'visible', 'on');
        savefig(f_new, fileN);
        kVIS_terminalMsg('Print complete.')
    end

end

delete(f3)
close(f_new);


end
