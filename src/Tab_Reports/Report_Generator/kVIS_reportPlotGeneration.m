%
%> @file kVIS_reportPlotGeneration.m
%> @brief Generate plots for a report from a custom plot definition
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
%> @brief Generate plots for a report from a custom plot definition
%>
%> @param hObject
%> @param Name of custom plot definition
%> @param Path of report output folder (plots will be generated in a subfolder ./img)
%
function fileNames = kVIS_reportPlotGeneration(hObject, plotName, plotNo, outFolder)

try
    [fds, ~] = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

%
% Read plot definition
%

if endsWith(plotName,".xlsx")
    try
    [~,~,PlotDefinition] = xlsread(plotName,'','','basic');
    catch
        errordlg('Plot definition does not exist.')
        fileNames = [];
        return
    end
end


% % % plot full data length
% if handles.uiTabPlots.plotsUseLimitsBtn.Value == 0
%     
%     xlim = kVIS_fdsGetGlobalDataRange(hObject);
%     
% else % use X-Limits (if button pressed or for events)
%     
%     xlim = kVIS_getDataRange(hObject, 'XLim');
%     
% end
xlim = [fds.fdataAttributes.startTimes(2) fds.fdataAttributes.stopTimes(2)];

tic

fileNames = kVIS_generateReportPlotXLS(fds, PlotDefinition, plotNo, xlim, [], outFolder);

toc

end

