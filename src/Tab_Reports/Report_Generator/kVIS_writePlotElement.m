function kVIS_writePlotElement(fid, fileName)

fprintf(fid,'\n\n');

fprintf(fid,'\\begin{figure}[!ht]\n');
fprintf(fid,'\\center\n');
fprintf(fid,'\\includegraphics[width=\\textwidth]{%s}\n',fileName);
fprintf(fid,'\\caption{Some plot}\n');
fprintf(fid,'\\label{lbl}\n');
fprintf(fid,'\\end{figure}\n');

end