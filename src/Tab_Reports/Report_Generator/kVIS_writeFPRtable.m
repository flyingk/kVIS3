function kVIS_writeFPRtable(hObject, fid)
%KVIS_WRITEFPRTABLE Summary of this function goes here
%   Detailed explanation goes here

try
    [fds, ~] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

% tbl = fds.flightPathReconstructionResults.States;
% fid = tblwrite(fid, tbl);
% 
% tbl = fds.flightPathReconstructionResults.DervStates;
% fid = tblwrite(fid, tbl);
% 
% tbl = fds.flightPathReconstructionResults.Param;
% fid = tblwrite(fid, tbl);

tbl = fds.EKF.Ptable;
tblwrite(fid, tbl);

end

function fid = tblwrite(fid, tbl)

Nparam = size(tbl,1);

fprintf(fid, '\n\n\n');

fprintf(fid, '\\begin{table}[!h]\n');
fprintf(fid, '\\tiny\n');
fprintf(fid, '\\begin{center}\n');
fprintf(fid, '\\caption{Error parameter estimates}\n');
fprintf(fid, '\\begin{tabular}{|l|r|r|}\n');
fprintf(fid, '\\hline\n');
fprintf(fid, 'Parameter & Value & Standard Dev. \\\\ \n');
fprintf(fid, '\\hline\n');

for ip=15:Nparam
    
    pnames = tbl{ip,1};
    param = tbl{ip,7};
    serr = tbl{ip,8};
    
    fprintf(fid, '$ %s $ & %g & $\\pm$%g \\\\ \n',...
        pnames, param, serr);
    
    fprintf(fid, '\\hline\n');
end

fprintf(fid, '\\end{tabular} \n');
fprintf(fid, '\\end{center}\n');
fprintf(fid, '\\end{table}\n');
end

