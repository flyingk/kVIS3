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

function kVIS_wpExport_Callback(hObject,~)
%
% export event(s) as individual fds files
%

handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

% Get the open fds files
[fds, names, idx] = kVIS_getAllFds(hObject)

if isempty(names)
    errordlg('Nothing loaded...')
    return
end

%
% more than one fiel open - export is all?
%
if length(fds) > 1

    button0 = questdlg({['Open Datasets: ', num2str(length(fds))],'Export all events?'},'Event export','All Files','Active','Cancel','Active');

end


if strcmp(button0, 'Active')

    %
    % get selected row(s) from user data field, if any
    %
    try
        EventSelected = eventList.UserData.rowSelected;
    catch
        EventSelected = [];
    end

    if isempty(EventSelected)

        button = questdlg({['Active Dataset: ',names{idx}],'Export all events?'},'Event export','All Files','All','Cancel','All');

    else

        button = questdlg({['Dataset: ',names{idx}],'Export all or selected events?'},'Event export','All','Selected','Cancel','All');

    end

    if strcmp(button, 'Cancel')
        return
    end

    doExport(fds{idx}, names{idx}, button, EventSelected);

elseif strcmp(button0, 'All Files')
    for I = 1:length(fds)
        doExport(fds{I}, names{I}, 'All', []);
    end
else
    return
end


kVIS_terminalMsg('Export Complete.');
end



function doExport(fds, name, button, EventSelected)

% promt for file name template
prompt = {'Enter file name template:'};
dlg_title = 'Export file name';
num_lines = 1;
def = {[name,'_event']};
answer = inputdlg(prompt,dlg_title,num_lines,def);
name_template = answer{1};

% Get number of events
n_events = numel(fds.eventList);

%
% Export only selected events
%
if strcmp(button, 'Selected')
    
    n_events = EventSelected';
else
    
    n_events = 1:n_events;
end

% Loop through each of the events
for ii = n_events
    %
    % Get time limits
    %
    start = fds.eventList(ii).start;
    stop  = fds.eventList(ii).end;
    eventID = fds.eventList(ii).type;
    
    fprintf('Exporting event %3d : %6.1f s to %6.1fs\n',ii,start,stop);
    
    %
    % edit the file
    %
    [fdsExport, ~] = kVIS_fdsTrimToTimeRange(fds, [start,stop]); %#ok<ASGLU>

    %
    % Save file
    %
    fname = [strip(name_template), '_', num2str(ii), '_', strip(eventID)];

    save(fname, 'fdsExport')
    
end

end