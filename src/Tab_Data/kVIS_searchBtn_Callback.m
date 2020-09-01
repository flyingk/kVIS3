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

function kVIS_searchBtn_Callback(hObject, ~)

handles = guidata(hObject);

fds = kVIS_getCurrentFds(hObject);

% disp('Search Results:')
% disp('===============')
% disp(' ')

searchStr = handles.uiTabData.groupSearchString.String;

% % search for groups
% findGroups = contains(fds.fdata(fds.fdataRows.groupLabel, :), searchStr, 'IgnoreCase',true);
% 
% if ~any(findGroups)
%     disp('No match in group names found...')
%     disp(' ')
% else
%     GroupResults = fds.fdata{fds.fdataRows.groupLabel, findGroups}
%     disp(' ')
% end

% search for channels
findChan = {};
searchStr_split = split (searchStr, ' ');

%% Search engine
% - Each word separated by a space is separated query
% - If the word starts with a "-" then channels that contains that word are
% removed from the filter
% - Show channels that fulfils all queries (AND of all queries)
% - If no word is filled in the search box, shows all available channels.
% - The search considers the name of the group and channel.
for i = 1:size(fds.fdata,2)
    if ~isempty(fds.fdata{fds.fdataRows.varNames, i})
        % Check all filter criterias
        a = ones(size(fds.fdata{fds.fdataRows.varNames, i},1), size(fds.fdata{fds.fdataRows.varNames, i},2));
            for iFilt = 1:length(searchStr_split)
                if isempty(searchStr_split{iFilt})
                    continue;
                elseif searchStr_split{iFilt}(1) == '-'
                    a = (a & ~(...
                        contains(lower(fds.fdata{fds.fdataRows.varNames, i}),   lower(searchStr_split{iFilt}(2:end))) | ... 
                        contains(lower(fds.fdata{fds.fdataRows.groupLabel, i}), lower(searchStr_split{iFilt}(2:end))) ) ...
                        );
                else
                    a = (a & (...
                        contains(lower(fds.fdata{fds.fdataRows.varNames, i}),   lower(searchStr_split{iFilt})) | ... 
                        contains(lower(fds.fdata{fds.fdataRows.groupLabel, i}), lower(searchStr_split{iFilt})) ) ...
                        );
                end
            end
        % Consolidate filter results
        if any(a)
            channel = find(a==true);            
            for j = 1:length(channel)
                res = [num2str(i) '/' ...
                       num2str(channel(j)) '/' ...
                       fds.fdata{fds.fdataRows.groupLabel, i} '/' ...
                       fds.fdata{fds.fdataRows.varNames, i}{channel(j)}];             
                findChan = [findChan res];
            end
        end
    end
end

%% Display results
% Reuse Data Channels box to display filter results.
if ~isempty(findChan)
    set(handles.uiTabData.channelListbox,'Value',1);
    set(handles.uiTabData.channelListbox,'String',findChan);
    handles.uiTabData.channelListboxLabel.String = 'Search Results';
else
    warndlg('No match for search query found...')
end

return

if ~isempty(findChan)
%     disp('ChannelResults:')
%     disp(' ')
%     for i = 1: length(findChan)
%         fprintf('%d) %s\n', i, findChan{i})
%     end
    
    sel = listdlg('ListString', findChan, 'ListSize', [300,500],...
        'SelectionMode','single','PromptString','Search results:','OkString','Select');
else
    sel = [];
    disp('No match in channel names found...')
end

%
% open tree  and plot signal for selected result
%
if ~isempty(sel)
    
    str = strsplit(findChan{sel},'/');
    
    % open tree group
    kVIS_fdsUpdateSelectionInfo(hObject, str2double(str{1}))
    
    fds = kVIS_getCurrentFds(hObject);
    
    kVIS_groupTreeUpdate(hObject, fds, 'default')
    
    % set channel list entry
    set(handles.uiTabData.channelListbox,'Value', str2double(str{2}));
    
    kVIS_channelList_Callback(hObject, [])
end
end

