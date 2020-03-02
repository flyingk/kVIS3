%
%> @file kVIS_updateCustomPlotList_Callback.m
%> @brief Builds a tree structure from the contents of the CustomPlots directory inside the BSP
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
%> @brief Builds a tree structure from the contents of the CustomPlots dir inside the BSP
%>
%> @param Standard GUI handles
%> @param Standard GUI events
%
function [] = kVIS_updateCustomPlotList_Callback(hObject, ~)

handles = guidata(hObject);

BSP_Path = getpref('kVIS_prefs','bspDir');
BSP_CustomPlots_Path = fullfile(BSP_Path, 'CustomPlots');

if exist(BSP_CustomPlots_Path, 'dir')
    
    fileList = dir(BSP_CustomPlots_Path);
    fileListCell = struct2cell(fileList);
    
    % get valid plot names
    fileNames = ~startsWith(fileListCell(1,:), ".");
    
else
    errordlg('Custom plot folder not found...')
    return
end

% tree handle
tree = handles.uiTabPlots.customPlotTree;

% Clear the tree.
delete(tree.Root.Children);

% build tree (currently one level of subdirs only)
for I = find(fileNames==true)
    
    % new directory
    if fileListCell{5,I} == true
        parent_node = tree.Root;
        
        % Create the directory node.
        pnode = uiw.widget.TreeNode( ...
            'Name', fileListCell{1,I}, ...
            'Value', I, ...
            'TooltipString', [], ...
            'Parent', parent_node ...
            );
        
        % directory contents
        dirFileList = dir(fullfile(BSP_CustomPlots_Path, fileListCell{1,I}));
        dirFileListCell = struct2cell(dirFileList);
        
        % get valid plot names
        dirFileNames = ~startsWith(dirFileListCell(1,:), ".");
        
        for M = find(dirFileNames==true)
            
            uiw.widget.TreeNode( ...
                'Name', dirFileListCell{1,M}, ...
                'Value', M, ...
                'TooltipString', [], ...
                'Parent', pnode, ...
                'UserData',fullfile(BSP_CustomPlots_Path, fileListCell{1,I}, dirFileListCell{1,M}) ...
                );            
        end
        
    else
        % top level files
        parent_node = tree.Root;
        
        % Create the node.
        uiw.widget.TreeNode( ...
            'Name', fileListCell{1,I}, ...
            'Value', I, ...
            'TooltipString', [], ...
            'Parent', parent_node, ...
            'UserData',fullfile(BSP_CustomPlots_Path, fileListCell{1,I}) ...
            );
    end
    
end

guidata(hObject, handles);
end