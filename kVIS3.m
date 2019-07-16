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

function kVIS3()

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
wTB = any(any(strcmp(checkInst, 'Widgets Toolbox')));
gTB = any(any(strcmp(checkInst, 'GUI Layout Toolbox')));

if wTB == false || gTB == false
    disp('Please install required toolboxes provided in ''Contributed'' folder.')
    return
end

% run prefs file
kVIS_prefs = kVIS_preferences;

if isempty(kVIS_prefs.bsp_dir)
    errordlg('No Board Support Package specified - Abort.')
    return
end

% Update Matlab path
addpath(genpath('src'));
addpath(genpath('contributed'));
addpath(genpath(kVIS_prefs.bsp_dir));
addpath(kVIS_prefs.sidpac_path);

% Read BSP info
try
    kVIS_prefs.BSP_Info = BSP_ID();
catch
    errordlg('No valid Board Support Package found...')
    return
end

% Initialize GUI.
kVIS_uiSetupFramework(kVIS_prefs);

end