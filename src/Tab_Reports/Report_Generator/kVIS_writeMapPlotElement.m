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
function fileNames = kVIS_writeMapPlotElement(hObject, pathColorChannel, outFolder)

% run bsp function
figHdl = feval('kVIS_createMap_Callback', hObject, [], pathColorChannel);

% gen file ID
id = randi(10000);

% save returned figures
for I = 1:length(figHdl)
    
    fcnName = ['mapPlot'];
    
    % save figures
    fileNames{1,I} = fullfile(outFolder, 'img', [fcnName '_' num2str(id) '.jpeg']);
    print(figHdl(I),'-noui',fileNames{1,I}, '-djpeg', '-r200')
    
    % relative path
    fileNames{1,I} = ['./img/' fcnName '_' num2str(id) '.jpeg'];
    fileNames{2,I} = figHdl(I).Name;
    
    delete(figHdl);
    
end