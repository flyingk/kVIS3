%
%> @file kVIS_generateReport.m
%> @brief Generate LaTeX file from report definition file
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
%> @brief Generate LaTeX file from report definition file
%>
%> @param hObject
%> @param Report definition file name
%>
%
function kVIS_generateReport(hObject, file)

% open report definition file
fidIN = fopen(file,'r');

% select destination folder
outFolder = uigetdir();

% create plot directory
mkdir(fullfile(outFolder,'img'))

fidOUT = fopen(fullfile(outFolder,'kVIS_report_dev.tex'),'w');


while ~feof(fidIN)
    
    l = strip(fgetl(fidIN));
    
    if contains(l, '%_kVIS_aircraft_properties')
        kVIS_writeAcDataTable(fidOUT);
        
    elseif contains(l, '%_kVIS_test_info')
        kVIS_writeTestInfoTable(fidOUT);
        
    elseif contains(l, '%_kVIS_plot')
        disp('plots')
        
        % generate plots
        if contains(l, '[')
            pltName = strsplit(l,{'{','}','[',']'});
            pltNo = str2double(strsplit(pltName{2},','));
            fileNames = kVIS_reportPlotGeneration(hObject, pltName{3}, pltNo, outFolder);
        else
            pltName = strsplit(l,{'{','}'});
            pltNo = [];
            fileNames = kVIS_reportPlotGeneration(hObject, pltName{2}, pltNo, outFolder);
        end
        
        % generate tex with plot names
        for I = 1:length(fileNames)
            if ~isempty(fileNames{1,I})
                kVIS_writePlotElement(fidOUT, fileNames(:,I));
            end
        end
        
    else
        fprintf(fidOUT,'%s\n',l);
    end
    
end

fclose(fidIN);
fclose(fidOUT);
end

