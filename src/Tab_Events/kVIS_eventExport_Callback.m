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

function kVIS_eventExport_Callback(hObject,~)
%
% export event(s) as individual fds files
%

% Get the current fild file
[fds, name] = kVIS_getCurrentFds(hObject);

if isempty(name)
    errordlg('Nothing loaded...')
    return
end

handles = guidata(hObject);

eventList = handles.uiTabEvents.eventTable;

%
% get selected row(s) from user data field, if any
%
try
    EventSelected = eventList.UserData.rowSelected;
catch
    EventSelected = [];
end

if isempty(EventSelected)

    button = questdlg({['Dataset: ',name],'Export all events?'},'Event export','All','Cancel','All');

else
    
    button = questdlg({['Dataset: ',name],'Export all or selected events?'},'Event export','All','Selected','Cancel','All');

end

if strcmp(button, 'Cancel')
    return
end


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

kVIS_terminalMsg('Export Complete.');
end