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

function [] = kVIS_updateCustomPlotList_Callback(hObject, ~)

handles = guidata(hObject);

BSP_Path = getpref('kVIS_prefs','bspDir');
BSP_CustomPlots_Path = fullfile(BSP_Path, 'CustomPlots');

if exist(BSP_CustomPlots_Path, 'dir')
    
    list = dir(BSP_CustomPlots_Path);
    ll = struct2cell(list);
    
    % get valid plot names
    aa = ~startsWith(ll(1,:), ".");
    
else
    disp('Custom plot folder not found...')
    return
end

tree = handles.uiTabPlots.customPlotListBox;

% Clear the tree.
delete(tree.Root.Children);

parent_node = tree.Root;

% build tree (currently one level only)
for I = find(aa==true)
    
    if ll{5,I} == true % new dir
        parent_node = tree.Root;
        
        % Create the directory node.
        pnode = uiw.widget.TreeNode( ...
            'Name', ll{1,I}, ...
            'Value', I, ...
            'TooltipString', [], ...
            'Parent', parent_node ...
            );
        
        % directory contents
        dlist = dir(fullfile(BSP_CustomPlots_Path, ll{1,I}));
        lll = struct2cell(dlist);
        
        % get valid plot names
        bb = ~startsWith(lll(1,:), ".");
        
        for M = find(bb==true)
            
            node = uiw.widget.TreeNode( ...
                'Name', lll{1,M}, ...
                'Value', M, ...
                'TooltipString', [], ...
                'Parent', pnode, ...
                'UserData',fullfile(BSP_CustomPlots_Path, ll{1,I}, lll{1,M}) ...
                );
            
        end
        
    else
        parent_node = tree.Root;
        
        % Create the node.
        uiw.widget.TreeNode( ...
            'Name', ll{1,I}, ...
            'Value', I, ...
            'TooltipString', [], ...
            'Parent', parent_node, ...
            'UserData',fullfile(BSP_CustomPlots_Path, ll{1,I}) ...
            );
    end
    
end






















guidata(hObject, handles);
end