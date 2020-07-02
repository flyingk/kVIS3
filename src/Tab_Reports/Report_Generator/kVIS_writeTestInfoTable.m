function kVIS_writeTestInfoTable(fid)

fds = evalin('base','ARQ_105');

t = fds.testInfo;

fprintf(fid,'\n\n');

fprintf(fid,'\\begin{table}[!h]\n');
fprintf(fid,'\\begin{center}\n');
fprintf(fid,'\\begin{tabular}{|l|r|r|r|r|r|}\n');
fprintf(fid,'\\hline\n');
fprintf(fid,'Date & Test &  Pilot  &  FTE  &  Location & ARQ No. \\\\ \n');
fprintf(fid,'\\hline\n');

fprintf(fid,'%s & %s &  %s  &  %s  &  %s & %s \\\\ \n',...
    t.date, t.description, t.pilot, t.BSP_FTE, t.location, t.BSP_arqNo);
fprintf(fid,'\\hline\n');

fprintf(fid,' Weather & Pressure &  Temperature  &  Wind Dir.   & Wind Speed  & Airfield Elevation \\\\ \n');
fprintf(fid,'\\hline\n');

fprintf(fid,' %s & %d &  %d &  %d   & %.1f  & %d \\\\ \n',...
    t.weather, t.ambientPressure_UNIT_Pa, t.ambientTemperature_UNIT_C, t.windDir_UNIT_deg, t.windSpeed_UNIT_m_d_s, t.airfieldElevation_UNIT_m);
fprintf(fid,'\\hline\n');

fprintf(fid,'\\end{tabular} \n');
fprintf(fid,'\\end{center}\n');
fprintf(fid,'\\caption{Test Information}\n');
fprintf(fid,'\\end{table}\n');

end

