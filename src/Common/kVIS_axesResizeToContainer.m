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

function kVIS_axesResizeToContainer(ax)
%
% Maximise axes usage of available container area
%

% panel type
pt = ax.Parent.Tag;

% restore property so that axes never get larger than container
ax.ActivePositionProperty = 'outerposition';
% max dimensions
outerpos = [0 0 1 1];
% required space for labels
ti = ax.TightInset;

if strcmp(pt, 'timeplot')
    
    % format axes - keep some minimum margins
    left   = max([0.04 ti(1)]);
    bottom = ti(2);
    ax_width = outerpos(3) - left - max([0.03 ti(3)]);
    ax_height = outerpos(4) - bottom - 0.015;
    
elseif strcmp(pt, 'mapplot')
    
    left   = max([0.04 ti(1)]);
    bottom = ti(2);
    ax_width = outerpos(3) - left - max([0.03 ti(3)]);
    ax_height = outerpos(4) - bottom - max([0.04 ti(4)]);
    
end

% update axes position
ax.Position = [left bottom ax_width ax_height];

end

