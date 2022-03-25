function kVIS_writeFPRtable(hObject, fid)
%KVIS_WRITEFPRTABLE Summary of this function goes here
%   Detailed explanation goes here

try
    [fds, ~] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

tbl = fds.flightPathReconstructionResults.States;
fid = tblwrite(fid, tbl);

tbl = fds.flightPathReconstructionResults.DervStates;
fid = tblwrite(fid, tbl);

tbl = fds.flightPathReconstructionResults.Param;
fid = tblwrite(fid, tbl);

end

function fid = tblwrite(fid, tbl)

Nparam = size(tbl,1);

fprintf(fid, '\n\n\n');

fprintf(fid, '\\begin{table}[!h]\n');
fprintf(fid, '\\begin{center}\n');
fprintf(fid, '\\caption{}\n');
fprintf(fid, '\\begin{tabular}{|l|r|r|r|c|}\n');
fprintf(fid, '\\hline\n');
fprintf(fid, 'Parameter & Value &  Standard Dev.  &  Std. Dev. in \\%%   &   95\\%% conf. interval \\\\ \n');
fprintf(fid, '\\hline\n');

for ip=1:Nparam
    
    pnames = tbl{ip,1};
    param = tbl{ip,2};
    serr = tbl{ip,3};
    serr_rel = tbl{ip,4};
    cbL = tbl{ip,5};
    cbU = tbl{ip,6};
    serro = serr * 5;
    serro_rel = serr_rel * 5;
    
    fprintf(fid, '%s & %6.3f & $\\pm$%6.3f (%6.3f) & %4.2f (%4.2f) & [ %6.3f %6.3f ] \\\\',...
        pnames, param, serr, serro, serr_rel, serro_rel, cbL, cbU);
    
    fprintf(fid, '\\hline\n');
end

fprintf(fid, '\\end{tabular} \n');
fprintf(fid, '\\end{center}\n');
fprintf(fid, '\\end{table}\n');
end

