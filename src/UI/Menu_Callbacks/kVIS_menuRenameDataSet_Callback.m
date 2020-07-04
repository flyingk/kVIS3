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

function kVIS_menuRenameDataSet_Callback(hObject, ~)
%
% rename a dataset
%

%
% get current selection
% 
[currentVal, currentName, ~, ~] = kVIS_dataSetListState(hObject);

if currentVal == 0
    return
end
%
% get new name (valid matlab var name required)
%
newName = {''};

while ~isvarname(newName{1})
    
    newName = inputdlg({'New Name'}, 'Rename Data Set', 1, {currentName});
    
    % cancel
    if isempty(newName)
        return
    end
    
    % check name
    if ~isvarname(newName{1})
        he = errordlg('Not a valid Matlab variable name...');
        newName = {''};
        uiwait(gcf, 2)
        delete(he);
    end
    
    % check duplication
    str = sprintf('exist(''%s'', ''var'')', newName{1});
    
    if evalin('base',str)
        he = errordlg('Name exists...');
        newName = {''};
        uiwait(gcf, 2)
        delete(he);
    end
    
end
%
% rename (copy) workspace fds variable to new name
%
str = sprintf('%s =  %s;', newName{1}, currentName);
try
    evalin('base', str);
catch
    errordlg('Workspace fds rename failed...')
    return
end
%
% update data set list entry
%
h = guidata(hObject);

h.uiTabData.dataSetList.String{currentVal} = newName{1};
%
% delete old workspace var
%
str = sprintf('clear %s;', currentName);
evalin('base', str);

kVIS_terminalMsg('Rename successful.')
end

