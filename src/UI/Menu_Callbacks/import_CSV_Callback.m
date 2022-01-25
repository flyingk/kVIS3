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

function import_CSV_Callback(hObject, ~)

[file, pathname] = uigetfile('*.csv');

if file==0
    return
end

% % generate data set name from file name - what about the same name twice??
% filen = split(file,'.');
% filen = strrep(filen{1},'-','_');
% if strlength(filen) > 63
%     filen = filen(1:59);
% end
% 
% handles=guidata(hObject);
% 
% str = handles.flight_list.String;
% 
% % set flight list box entries
% if size(str,1) == 1 && strcmp(str, 'Flights')
%     flightVar = ['FDS_' filen];
%     str = {};
% else
%     flightVar = ['FDS_' filen];
% end
% 
% disp(file);

file = fullfile(pathname,file);

% fid = fopen(file);
% 
% l = fgetl(fid);
% 
% fclose(fid);
% 
% names = split(l,';');
% units = cell(size(names));
% 
% for I = 1:size(names,1)
%    
%     names{I} = ['  ' names{I}];
%     units{I} = '()';
%     
% end

T = readtable(file, 'Range', 'A1:Z100');

%% fill fds with data
fds = kVIS_fdsInitNew();

fds.BoardSupportPackage = 'Generic_CSV';

fds.fdata{fds.fdataRows.Label,1} = 'CSV Contents';
fds.fdata{fds.fdataRows.Vars, 1} = names;
fds.fdata{fds.fdataRows.Units,1} = units;
fds.fdata{fds.fdataRows.VarLabels_TeX,1} = names;
fds.fdata{fds.fdataRows.Data,1}  = data;
fds.fdata{fds.fdataRows.Parent,1} = 0;
fds.fdata{fds.fdataRows.GUIexpanded,1}  = true;
fds.fdata{fds.fdataRows.GUIselected,1}  = false;

fds = fds_update_attributes(fds);

%% Update workspace

assignin('base', flightVar, fds);

handles.flight_list.String = [str; flightVar];
handles.flight_list.Value  = numel(handles.flight_list.String);

update_workspace(hObject, fds, flightVar);

guidata(hObject, handles);

end
