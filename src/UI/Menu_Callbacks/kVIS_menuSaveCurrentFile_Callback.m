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

function kVIS_menuSaveCurrentFile_Callback(hObject, ~)
%
% saves current file to the destination it was loaded from (if available)
%

[~, currentName, ~] = kVIS_dataSetListState(hObject);

if isempty(currentName)
    return;
end

% retrive file location - call save as if not available
try
    cmd = [currentName '.pathOpenedFrom'];
    fileN = evalin('base', cmd);
catch
    kVIS_menuSaveCurrentFileAs_Callback(hObject, [])
    return
end

if isempty(fileN)
    kVIS_menuSaveCurrentFileAs_Callback(hObject, [])
    return;
end

kVIS_terminalMsg(['Saving as ' fileN '...']);

% clear file location field
cmd = [currentName '.pathOpenedFrom=[];'];
evalin('base', cmd);

% save file (overwrite)
cmd = sprintf('save(''%s'', ''%s'', ''-v7.3'')', fileN, currentName);
evalin('base', cmd)

% restore file location field
cmd = [currentName '.pathOpenedFrom=''' fileN ''';'];
evalin('base', cmd);

kVIS_terminalMsg('Writing file... Complete');

end