%
%> @file kVIS_writeTitle.m
%> @brief Write report title
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
%> @brief Write report title
%>
%> @param File identifier to print to
%>
%
function kVIS_writeTitle(hObject, fid)

try
    [fds, ~] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

t = fds.testInfo;

test_ID = split(fds.pathOpenedFrom,'\');
test_ID = test_ID(end);
test_ID = split(test_ID,'_');
test_ID = strcat(test_ID(1),'-',test_ID(2),'-',test_ID(3));

% fprintf(fid,'\n\n');

%%%% Lorenzo workaround
% fprintf(fid,['\\title{Lilium Phoenix 1 Flight Report\\\\' t.BSP_arqNo '}']);
fprintf(fid,['\\title{Lilium Phoenix II Flight Report\\\\' test_ID{1} '}']);
% fprintf(fid,['\\title{Lilium Phoenix II Flight Report}\']);
%%%%
    


% fprintf(fid,'\\begin{table}[!h]\n');
% fprintf(fid,'\\begin{center}\n');
% fprintf(fid,'\\begin{tabular}{|l|r|r|r|}\n');
% fprintf(fid,'\\hline\n');
% fprintf(fid,'Date & Test &  Pilot  &  FTE \\\\ \n');
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,'%s & %s &  %s  &  %s\\\\ \n',...
%     t.date, t.description, t.pilot, t.BSP_FTE);
% fprintf(fid,'\\hline\n');
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,'Location & ARQ No. & Weather & Airfield Elevation [$m$]\\\\ \n');
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,'%s & %s &  %s  & %d\\\\ \n',...
%     t.location, t.BSP_arqNo, t.weather, t.airfieldElevation_UNIT_m);
% fprintf(fid,'\\hline\n');
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,'Pressure [$Pa$] &  Temperature [$^{\\circ} C$]  &  Wind Dir. [$deg$]  & Wind Speed [$m/s$]\\\\ \n');
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,' %d &  %d &  %d   & %.1f\\\\ \n',...
%      t.ambientPressure_UNIT_Pa, t.ambientTemperature_UNIT_C, t.windDir_UNIT_deg, t.windSpeed_UNIT_m_d_s);
% fprintf(fid,'\\hline\n');
% 
% fprintf(fid,'\\end{tabular} \n');
% fprintf(fid,'\\end{center}\n');
% fprintf(fid,'\\caption{Test Information}\n');
% fprintf(fid,'\\end{table}\n');

end

