function kVIS_deleteTreeGroup(source, ~, hObject, entry)

disp('delete tree group - WiP')

% menu entry - no use
source;

[fds, name] = kVIS_getCurrentFds(hObject);

% group ID
entry;

idx = strcmp(fds.fdata(fds.fdataRows.groupID,:), entry);

grp = find(idx==true)

% remove group
fds.fdata = fds.fdata(:,[1:grp-1, grp+1:end]);

% set selected group to parent so tree stays open
% TODO

% update app
kVIS_updateDataSet(hObject, fds, name);

end

