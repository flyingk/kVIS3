%
%> @file writeAcDataTable.m
%> @brief Add a table with aircraft data struct content to the report
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
%> @brief Add a table with aircraft data struct content to the report
%>
%> @param File identifier to print to
%>
%
function kVIS_writeAcDataTable(hObject, fid)

try
    [fds, ~] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

a = fds.aircraftData;

fprintf(fid,'\n\n');

fprintf(fid,'\\begin{table}[!h]\n');
fprintf(fid,'\\begin{center}\n');
fprintf(fid,'\\begin{tabular}{|l|r|r|r|r|r|}\n');
fprintf(fid,'\\hline\n');
fprintf(fid,'Aircraft & $Mass\\; [kg]$ &  $I_{xx}\\; [kgm^2]$  &  $I_{yy}\\; [kgm^2]$   &  $I_{zz}\\; [kgm^2]$ & $I_{xz}\\; [kgm^2]$ \\\\ \n');
fprintf(fid,'\\hline\n');

fprintf(fid,'%s & %.2f &  %.2f  &  %.2f  &  %.2f & %.2f \\\\ \n',...
    a.acIdentifier, a.mass_UNIT_kg, a.ixx_UNIT_kgm2, a.iyy_UNIT_kgm2, a.izz_UNIT_kgm2, a.ixz_UNIT_kgm2);
fprintf(fid,'\\hline\n');
fprintf(fid,'\\hline\n');

fprintf(fid,'  & $X_{CG}\\;[m]$ &  $Y_{CG}\\;[m]$  &  $Z_{CG}\\;[m]$   & FCC Version  & FCL Version \\\\ \n');
fprintf(fid,'\\hline\n');

% fprintf(fid,'  & %.3f &  %.3f  &  %.3f   & %s  & %s \\\\ \n',...
%     a.xCG_UNIT_m, a.yCG_UNIT_m, a.zCG_UNIT_m, a.BSP_fccSoftware, a.BSP_fclVersion);

%%%% Lorenzo workaround
fprintf(fid,'  & %.3f &  %.3f  &  %.3f\\\\ \n',...
    a.xCG_UNIT_m, a.yCG_UNIT_m, a.zCG_UNIT_m);
%%%%
fprintf(fid,'\\hline\n');

fprintf(fid,'\\end{tabular} \n');
fprintf(fid,'\\end{center}\n');
fprintf(fid,'\\caption{Aircraft Properties}\n');
fprintf(fid,'\\end{table}\n');

end

