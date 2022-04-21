%
%> @file kVIS_writeFcnPlotElement.m
%> @brief Add plot element to the report returned by a bsp function call
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
%> @brief Add a plot element to the report returned by a bsp function call
%>
%> @param hObject
%> @param bsp function name to call
%> @param folder path for images
%
function fileNames = kVIS_writeFcnPlotElement(hObject, fcnName, outFolder)

if size(fcnName,2) == 4
    % selected plots from output
    kVIS_terminalMsg(['Reports: Calling BSP function ' fcnName{3}])
    fcn = fcnName{3};
    pltIdx = str2double(fcnName{2});
else
    % all plots TODO
    kVIS_terminalMsg(['Reports: Calling BSP function ' fcnName{2}])
    fcn = fcnName{2};
    pltIdx = [];
    keyboard
end

% run bsp function
figHdl = feval(fcn, hObject, []);

% save returned figures
for I = pltIdx
    
    figHdl(I).Position = [0 0 750 325];
    
%     figHdl(I).Visible = 'on';
    
    % save figures
    fileNames{1,I} = fullfile(outFolder, 'img', [fcn '_' num2str(I) '.jpeg']);
    print(figHdl(I),'-noui',fileNames{1,I}, '-djpeg', '-r200')
    
    % relative path
    fileNames{1,I} = ['./img/' fcn '_' num2str(I) '.jpeg'];
    fileNames{2,I} = figHdl(I).Name;
    
end

close(figHdl)