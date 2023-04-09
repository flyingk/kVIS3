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

function appWindowHandle = kVIS3()

clc

disp('*********************************************************************')
disp(' ')
disp('kVIS3 Data Visualisation')
disp(' ')
disp('Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson')
disp('and contributors')
disp(' ')
disp('This program is distributed in the hope that it will be useful,')
disp('but WITHOUT ANY WARRANTY; without even the implied warranty of')
disp('MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the')
disp('GNU General Public License for more details.')
disp(' ')
disp('*********************************************************************')
disp(' ')
%
% check for required toolboxes
%
checkInst = ver;
checkInst = struct2cell(checkInst);
wTB = any(any(strcmp(checkInst, 'Widgets Toolbox - Compatibility Support')));
gTB = any(any(strcmp(checkInst, 'GUI Layout Toolbox')));

if wTB == false || gTB == false
    disp('Please install the required (updated) toolboxes provided in ''Contributed'' folder.')
    return
end

% get root folder
rootFolder = fileparts(which('kVIS3'));

% run prefs file
try
    kVIS_preferencesInit();
catch
    % Update Matlab path
    
    % add stuff from path below root folder
    addpath(genpath([rootFolder '/src']));
    addpath(genpath([rootFolder '/contributed']));
    kVIS_preferencesInit();
end

if isempty(getpref('kVIS_prefs','bspDir'))
    
    hdl = warndlg('Select BSP_ID.m file location.');
    
    pause(3)
    
    bspDir = uigetdir();
    
    delete(hdl)
    
    if bspDir == 0
        errordlg('No Board Support Package specified - Abort.')
        return
    end
    
    setpref('kVIS_prefs', 'bspDir', bspDir)
end

% Update Matlab path
addpath(genpath(getpref('kVIS_prefs','bspDir')));

% Read BSP info
try
    BSP_Info = BSP_ID();
catch
    errordlg('No valid Board Support Package found... Please restart to select a valid BSP')
    setpref('kVIS_prefs','bspDir', []);
    appWindowHandle = -1;
    return
end

% Initialize GUI.
BSP_Info.rootFolder = rootFolder;

% widget toolbox warning from 2019b
warning('off','MATLAB:ui:javacomponent:FunctionToBeRemoved')

appWindowHandle = kVIS_uiSetupFramework(BSP_Info);

end