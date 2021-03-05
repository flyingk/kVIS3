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

function kVIS_groupTreeUpdate(hObject, fds, mode)
% Update the file tree display, e.g. when selecting a flight from the
% flight list.

handles=guidata(hObject);

tree = handles.uiTabData.groupTree;

tree.RootVisible = false;

% Clear the tree.
delete(tree.Root.Children);

% Stop if no dataset is selected (e.g. when the last dataset is closed).
if isempty(fds)
    return;
end

fdata = fds.fdata;
% Create a list of TreeNode objects associated with the fdata entries.
fdata_nodes = uiw.widget.TreeNode.empty();


% Add nodes for all fdata entries.
for idx = 1 : size(fdata, 2)
    
    node_name = fdata{fds.fdataRows.groupLabel, idx};
    
    % Find the parent node (data group/subsystem/...); if no parent is
    % specified (parent_idx <= 0), then add the new node at the highest
    % level in the tree.
    parent_id = fdata{fds.fdataRows.treeParent, idx};
    
    if parent_id > 0
        % find parent based on unique group ID
        parent_idx= strcmp(fdata(fds.fdataRows.groupID,:), parent_id);

        parent_node = fdata_nodes(find(parent_idx==true)); %#ok<FNDSB>
    else
        parent_node = tree.Root;
    end
    
    % Create a tooltip indicating the number of variables that is available
    % at the new node.
    n_vars = fds.fdataAttributes.nChnls(idx);
    smplRate = fds.fdataAttributes.sampleRates(idx);
    switch n_vars
        case 0
            tooltip = sprintf('%d Channels', n_vars);
        case 1
            tooltip = sprintf('1 Channel - Sample rate: %.1f Hz', smplRate);
        otherwise
            tooltip = sprintf('%d Channels - Sample rate: %.1f Hz', n_vars, smplRate);
    end
    
    % Create the node.
    node = uiw.widget.TreeNode( ...
        'Name', node_name, ...
        'Value', idx, ...
        'TooltipString', tooltip, ...
        'Parent', parent_node, ...
        'UIContextMenu', kVIS_createTreeContextMenu(hObject, fdata{fds.fdataRows.groupID, idx}) ...
        );
    
    fdata_nodes = [ fdata_nodes, node ]; %#ok<AGROW>
    
    if fdata{fds.fdataRows.treeGroupExpanded}
        node.expand();
    end
    
end

% Restore selection state from information recorded in fds.
tree.SelectedNodes = fdata_nodes(cell2mat(fdata(fds.fdataRows.treeGroupSelected, :)));
if isempty(tree.SelectedNodes)
    % Select the first node by default
    tree.SelectedNodes = fdata_nodes(1);
end

if strcmp(mode,'search') == false
    kVIS_updateChannelList_Callback(hObject, [], 0);
end

end

function [ m ] = kVIS_createTreeContextMenu(hObject, idx)
    % This function creates a context menu for a given Line object.
    % The menu displays some metadata helping to identify the line, and
    % provides some callback actions.

    m = uicontextmenu();

%     % metadata section
%     uimenu('Parent', m, 'Label', sprintf('Signal: %s', strip(line.UserData.signalMeta.name)), 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Units: %s' , strip(line.UserData.signalMeta.unit))     , 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Data Set: %s', strip(line.UserData.signalMeta.dataSet)), 'Enable', 'off');

    uimenu( ...
        'Parent', m, ...
        'Label', 'Delete', ...
        'Separator','off',...
        'Callback', {@kVIS_deleteTreeGroup_Callback, hObject, idx} ...
        );
%     uimenu( ...
%         'Parent', m, ...
%         'Label', 'Apply Filter', ...
%         'Separator','on',...
%         'Callback', {@kVIS_plotLineContextMenuActions_Callback, line} ...
%         );
end