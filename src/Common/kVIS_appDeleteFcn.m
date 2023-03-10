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

function kVIS_appDeleteFcn(hObject, ~)

BSP_keepOnPath = false;

handles = guidata(hObject);

kVIS_Prefs = getpref('kVIS_prefs');

if isfield(handles.bspInfo, 'BSP_keepOnPath')
    if handles.bspInfo.BSP_keepOnPath == true
        BSP_keepOnPath = true;
    end
end

if kVIS_Prefs.clear_path_on_exit == 1 && BSP_keepOnPath == false
        
    % get root folder
    rootFolder = handles.bspInfo.rootFolder;
    
    % remove stuff from path below root folder
    rmpath(genpath([rootFolder '/src']));
    rmpath(genpath([rootFolder '/contributed']));
    
    % remove BSP stuff
    if ispref('kVIS_prefs','bspDir')
        rmpath(genpath(getpref('kVIS_prefs','bspDir')));
    end
    
    disp('PATH cleanup complete. kVIS out.')
    
else
    disp('kVIS remains on PATH. Good Bye')
end

end

