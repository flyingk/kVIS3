%
%> @file kVIS_writePlotElement.m
%> @brief Add plot element to the report
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
%> @brief Add a plot element to the report
%>
%> @param File identifier to print to
%> @param Cell array with plot file name and caption string (2x1 array)
%>
%
function kVIS_writePlotElement(fid, fileName)

lbl = strsplit(fileName{1},'/');

fprintf(fid,'\n\n');

fprintf(fid,'\\begin{figure}[!ht]\n');
fprintf(fid,'\\center\n');
fprintf(fid,'\\includegraphics[width=0.9\\textwidth]{%s}\n',fileName{1});
fprintf(fid,'\\caption{%s}\n',fileName{2});
fprintf(fid,'\\label{%s}\n',['figure:' lbl{end}]);
fprintf(fid,'\\end{figure}\n');

end