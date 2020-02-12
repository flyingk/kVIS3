%
%> @file kVIS_fdsImportDataGroup.m
%> @brief Add data from a CSV file to the current data tree
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
%> @brief Add data from a CSV file to the current data tree
%>
%> @param Application handle structure
%>
%> @retval none
%
function kVIS_fdsImportDataGroup(hObject, ~)
%
% Import data from csv file and add to current fds tree
%

[fds, name] = kVIS_getCurrentFds(hObject);

if ~isstruct(fds)
    errordlg('No data loaded to be assigned.')
    return
end



[file, pathname] = uigetfile('*.csv');

if file==0
    return
end

InputFile = fullfile(pathname,file);

Tmp = fopen(InputFile);
ExportNames  = strsplit(fgetl(Tmp), ',');
fclose(Tmp);




T = readtable(InputFile);

T.Properties;

Tr = table2array(T);

if iscell(Tr)
    errordlg('Faulty FTI file - contains non-numerical data. Abort')
    fds = -1;
    return
end


% add data to fds
fdata = Tr;

varNames = ExportNames';

varUnits = cell(size(varNames));
varUnits = cellfun(@(x) '', varUnits, 'UniformOutput', false);

varFrames = cell(size(varUnits));
varFrames = cellfun(@(x) '', varFrames, 'UniformOutput', false);

% select location in data tree
answ = inputdlg({'New Tree branch','New Group name'},'Select import names',1,{'Imported','FTI Data'});

if isempty(answ)
    return
end

% add data to tree
fds = kVIS_fdsAddDataGroup(fds, answ{1}, answ{2}, varNames, varUnits, varFrames, fdata);

kVIS_updateDataSet(hObject, fds, name)
end