%
%> @file kVIS_fdsDataMatrix2Tree.m
%> @brief Creates a FDS tree from a data matrix and corresponding data names.
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
%> @brief Creates a FDS tree from a data matrix and corresponding data names.
%>
%> Creates a FDS tree from a data matrix and corresponding data names. 
%> If name string can be split in to groups, the function will attempt to 
%> identify common groups using the delimiter. The sample time is assumed 
%> to be the first channel of the matrix and assumed common to all data.
%>
%> @param Name of BSP
%> @param Name of root node
%> @param Delimiter used in name list
%> @param Array of data channels in columns with time vector as column 1
%> @param Flag to skip last column - useful for CSV files with corrupt row endings
%>
%> @retval Created fds structure
%
function [fds] = kVIS_fdsDataMatrix2Tree(bspName, rootName, delimiter, dataNames, data, skipLast)

%
% init new fds
%
fds = kVIS_fdsInitNew();
%
% set bsp name
%
fds.BoardSupportPackage = bspName;
%
% add root node
%
[fds, parentNode0] = kVIS_fdsAddTreeBranch(fds, 0, rootName);


waitb = waitbar(0,'Building FDS structure. Please wait...');
%
% time vector - assumed common to all data
%
timeVec = data(:,1);
%
% build fds.fdata structure without data (initialise for speed, fill data
% in second step)
%
for k = 2 : numel(dataNames) - skipLast % first entry is time vector, last entry is potentially empty
    
    %updating waitbar every 10%
    hfrac = k/(numel(dataNames) - skipLast);
    if mod(hfrac,0.05)<0.001
        waitbar(hfrac, waitb)
    end
    
    Path = strsplit(dataNames{k}, delimiter);
    Path = strip(Path);

    Name = Path{end};
    Path = Path(1:end-1);
    
    if isempty(Path)
        Path = {'Unsorted'}; % put in default group
    end
    
    % Find or create group
    ParentIdx = parentNode0;
    
    for P = 1 : numel(Path)
        
        GroupName = Path{P};

        findLabel = strcmp(fds.fdata(fds.fdataRows.groupLabel, :), GroupName);
        
        findParent = cell2mat(fds.fdata(fds.fdataRows.treeParent, :));
        
        MatchingGroupIdx = findLabel & findParent;
        
        N_MatchingGroups = sum(MatchingGroupIdx);
        
        switch N_MatchingGroups
            
            case 0 % Add group
                
                if P == numel(Path)
                    % data leaf with time vector as first entry
                    [fds, node] = kVIS_fdsAddTreeLeaf(fds, GroupName, {'Time'}, {'Time'}, {'sec'}, {'-'}, timeVec(1), ParentIdx, false);
                    
                    [ fds ] = kVIS_fdsAddTreeLeafItem(fds, node, Name, Name, {'-'}, {'-'}, data(1,k));

                else
                    % sorting branch
                    [fds, ParentIdx] = kVIS_fdsAddTreeBranch(fds, ParentIdx, GroupName);
                end

            case 1 % existing group
                
                ParentIdx = find(MatchingGroupIdx);
                
                if P == numel(Path)
                    
                    if isempty(fds.fdata{fds.fdataRows.varNames, ParentIdx}) % new channels added after group created and filled with sub-groups
                        [ fds ] = kVIS_fdsAddTreeLeafItem(fds, ParentIdx, 'Time', 'Time', {'sec'}, {'-'}, timeVec(1));
                    end
                    
                    [ fds ] = kVIS_fdsAddTreeLeafItem(fds, ParentIdx, Name, Name, {'-'}, {'-'}, data(1,k));
                end
                
            otherwise
                error('This should not happen ...');
        end
    end
    
end
%
% pre-allocate data arrays
%
for k = 1:size(fds.fdata, 2)
    
    if size(fds.fdata{fds.fdataRows.varNames, k}) > 0
        
        fds.fdata{fds.fdataRows.data, k} = zeros(length(timeVec), size(fds.fdata{fds.fdataRows.data, k},2));
        
        fds.fdata{fds.fdataRows.data, k}(:,1) = timeVec;
    end
end
%
% copy data into fdata array
%
for k = 2 : numel(dataNames) - skipLast % first entry is time vector, last entry is potentially empty
    
    %updating waitbar every 10%
    hfrac = k/(numel(dataNames) - skipLast);
    if mod(hfrac,0.05)<0.001
        waitbar(hfrac, waitb)
    end
    
    Path = strsplit(dataNames{k}, delimiter);
    Path = strip(Path);

    Name = Path{end};
    Path = Path(1:end-1);
    
    if isempty(Path)
        Path = {'Unsorted'}; % put in default group
    end
    
    for P = 1 : numel(Path)
        
        GroupName = Path{P};

        findLabel = strcmp(fds.fdata(fds.fdataRows.groupLabel, :), GroupName);
        
        findParent = cell2mat(fds.fdata(fds.fdataRows.treeParent, :));
        
        MatchingGroupIdx = findLabel & findParent;
        
        groupIdx = find(MatchingGroupIdx);
        
        if P == numel(Path)
            [ fds ] = kVIS_fdsFillTreeLeafItemLocal(fds, groupIdx, Name, data(:,k));
        end
                
    end
    
end

fds = kVIS_fdsUpdateAttributes(fds);

close(waitb) 
end

function [ fds ] = kVIS_fdsFillTreeLeafItemLocal(fds, group, var, data)

%
% Add new data to a tree leaf. SPECIAL VERSION TO DEAL WITH NON-NUMERIC
% DATA...

% var
% fds.fdata{fds.fdataRows.varNames, group}
findChannel = strcmp(fds.fdata{fds.fdataRows.varNames, group}, var);

if sum(findChannel) > 1
    disp(['Duplicate channel name found in group. Skipping. <' var '>'])
    return
end

if ~isnumeric(data)
    %disp(['group' group 'contains non-numeric data... Bad :('])
    data = str2double(data);
end

fds.fdata{fds.fdataRows.data, group}(:,findChannel) = data;
end


