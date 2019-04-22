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

function file_close_current_Callback(hObject, ~)

% import package contents
cellfun(@import, KSID.import_package());

handles=guidata(hObject);

if isempty(handles.flight_list.String)
    return;
end

name = get_fds_name(handles, handles.flight_list.Value);

action = questdlg( ...
    sprintf('Delete ''%s'' from the workspace?', name), ...
    sprintf('Close flight ''%s''', name), ...
    'Close and keep data', 'Close and delete data', 'Cancel', ...
    'Close and keep data' ...
    );
switch action
    case 'Close and keep data'
        idx = handles.flight_list.Value;
        if numel(handles.flight_list.String) == idx
            handles.flight_list.Value = idx - 1;
        end
        handles.flight_list.String = handles.flight_list.String([1:idx-1, idx+1:end]);
        guidata(hObject, handles);
        if numel(handles.flight_list.String)
            flight_list_Callback(handles.flight_list, []);
        else
            updateFileTree(handles, []);
            update_channel_list_Callback(handles.sidpac_var_listbox, []);
        end
    case 'Close and delete data'
        idx = handles.flight_list.Value;
        evalin('base', sprintf('clear %s;', name));
        if numel(handles.flight_list.String) == idx
            handles.flight_list.Value = idx - 1;
        end
        handles.flight_list.String = handles.flight_list.String([1:idx-1, idx+1:end]);
        guidata(hObject, handles);
        if numel(handles.flight_list.String)
            flight_list_Callback(handles.flight_list, []);
        else
            updateFileTree(handles, []);
            update_channel_list_Callback(handles.sidpac_var_listbox, []);
        end
end

clear_plot_Callback(hObject, 0);