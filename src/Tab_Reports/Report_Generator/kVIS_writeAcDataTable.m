function kVIS_writeAcDataTable(fid)

fds = evalin('base','ARQ_105');

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

fprintf(fid,'  & $X_{CG}\\;[m]$ &  $Y_{CG}\\;[m]$  &  $Z_{CG}\\;[m]$   & FCC Version  & FCL Version \\\\ \n');
fprintf(fid,'\\hline\n');

fprintf(fid,'  & %.3f &  %.3f  &  %.3f   & %s  & %s \\\\ \n',...
    a.xCG_UNIT_m, a.yCG_UNIT_m, a.zCG_UNIT_m, a.BSP_fccSoftware, a.BSP_fclVersion);
fprintf(fid,'\\hline\n');

fprintf(fid,'\\end{tabular} \n');
fprintf(fid,'\\end{center}\n');
fprintf(fid,'\\caption{Aircraft Properties}\n');
fprintf(fid,'\\end{table}\n');

end

