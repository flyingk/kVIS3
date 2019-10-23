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
function kVIS_autoCutdown_Callback(hObject,~)

% Get the current fild file
fds = kVIS_getCurrentFds(hObject);

% Check to see if fdata has been filled.
% Easiest to check if << t >> of fdata is full
%
% This is a bit harder than it looks because we can't access the
% fill fdata call back given it's sitting in a different file @_@.
% Currently just dodge'd it and warn the user.  Perhaps there's a
% way in the code to pretend the user pressed the button...

signal = kVIS_fdsGetChannel(fds, 'fdata', 't');

if (signal == -1)
    % Make question box
    choice = questdlg('fdata not filled.  Fill and Save', 'ooops', ...
        'leave Empty','leave Empty');
%   choice = questdlg('fdata not filled.  Fill and Save', 'ooops', ...
%      'fill RAW','leave Empty','leave Empty');
    
    % Handle response
    switch choice
%         case 'fill RAW'
%             fprintf('Filling fdata using raw data\n');
%             
%             % Change pop-up box and fill data
%             set(hObject.source_popup,'Value',1);
%             fill_fdata_Callback(hObject, eventdata)
            
        case 'leave Empty'
            fprintf('Leaving fdata empty...\n');
            
    end
    
    if isempty(choice)
        % The close icon was pressed so do nothing
        return;
    end
end

% Import most recent fds struct in case fdata was filled
[fds_base, name] = kVIS_getCurrentFds(hObject);

% promt for file name template
prompt = {'Enter file name template:'};
dlg_title = 'Cutdown file name';
num_lines = 1;
def = {[name,'_cut']};
answer = inputdlg(prompt,dlg_title,num_lines,def);
name_template = answer{1};

% Get number of impulses
n_events = numel(fds_base.eventList);

% Loop through each of the impulese
for ii = 1:n_events
    start = fds_base.eventList(ii).start;
    stop  = fds_base.eventList(ii).end;
    
    fprintf('Processing event %3d : %6.1f s to %6.1fs\n',ii,start,stop);
    
    % Loop through each of the data sets and only take what we need
    fds = fds_base;
    
    for jj = 2:size(fds.fdata,2)
        % Find what we need
        locs =  (fds.fdata{7,jj}(:,1)) > start & (fds.fdata{7,jj}(:,1) < stop) ;
        
        % Fill with only the locs we want
        fds.fdata{7,jj} = fds.fdata{7,jj}(locs,:);
        
        % Correct the time vector to start at zero
        fds.fdata{7,jj}(:,1) = fds.fdata{7,jj}(:,1)-start; 

    end
    
    % Magic the fds file in here (Kai's scripts)
    
    % Save data file
    impulse_type = fds_base.eventList(ii).type;
    fname = sprintf('%s_%i_%s',name_template,ii,impulse_type);
        
    % Remove excess full stops
    fname = strrep(fname,'.','');
        
    % Add the file extension
    fname = [ fname, '.mat' ];
    
    % Save the file
    save(fname,'fds')
    
end

fprintf('\n\nCutdown Complete.\n\n');

return
end