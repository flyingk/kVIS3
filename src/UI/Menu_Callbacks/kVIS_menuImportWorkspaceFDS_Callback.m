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

function kVIS_menuImportWorkspaceFDS_Callback(hObject, ~)

% register in data set list - how to check for duplicates???

disp('kVIS_menuImportWorkspaceFDS_Callback: WARNING! will override existing workspace data!')

c = evalin('base','who');

% isstruct(c)

[s,ok] = listdlg('ListString',c, 'SelectionMode', 'single');

if ok == 0
    return
end

%
% get current selection
% 
[~, ~, ~, str] = kVIS_dataSetListState(hObject);
%
% does name exist?
%
if any(strcmp(c{s}, str))
    %
    % get new name (valid matlab var name required)
    %
    newName = {''};
    
    while ~isvarname(newName{1})
        
        newName = inputdlg({'New Name'}, 'Name:', 1, c(s));
        
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
        if any(strcmp(newName{1}, str))
            he = errordlg('Name exists...');
            newName = {''};
            uiwait(gcf, 2)
            delete(he);
        end
        
    end
    
else
    
    newName{1} = c{s};
    
end

fds = evalin('base',c{s});

% legacy format?
fds = kVIS_fdsUpgrade(fds);
    
kVIS_addDataSet(hObject, fds, newName{1})

end

