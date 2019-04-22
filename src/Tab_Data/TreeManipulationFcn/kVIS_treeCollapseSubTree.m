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

function kVIS_treeCollapseSubTree(root_node, flag_recurse)

assert(isa(root_node, 'uiw.widget.TreeNode'));
assert(islogical(flag_recurse));

for k = 1 : numel(root_node.Children)
    node = root_node.Children(k);
    % Collapse children first!
    if flag_recurse
        kVIS_treeCollapseSubTree(node, flag_recurse);
    end
    node.collapse();
end

end
