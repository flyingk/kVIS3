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

function kVIS_menuFileOpen_Callback(hObject, ~)

%load fds.mat and prepare
[file, pathname] = uigetfile('*.mat');

if file == 0
    return
end

fileN = fullfile(pathname,file);

data = load(fileN);

fn = fieldnames(data);

if isfield(data.(fn{1}), 'fdata')

    fds = kVIS_fdsUpgrade(data.(fn{1}));
    
    % save file origin for save function
    fds.pathOpenedFrom = fileN;
    
    %
    % BSP provided function for fds processing after loading
    %
    try
        fds = BSP_postLoadFcn(fds);
    catch
        disp('file open: no BSP post load function available...')
    end
    
    %
    % get new name (valid matlab var name required)
    %
    newName = {''};
    
    while ~isvarname(newName{1})
        
        newName = inputdlg({'New Name'}, 'Name:', 1, fn(1));
        
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
    
    kVIS_addDataSet(hObject, fds, newName{1});
    
else
    errordlg(sprintf('No `fds` struct found in %s.', file), 'Failed to load data', 'modal');
end