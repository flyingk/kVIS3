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

function [ fds ] = kVIS_fdsUpgradeLegacy(fds)
    % Upgrade the given FDS struct in legacy format (no formal specification)
    % to a format understood by fds_upgrade_V_0_V_1_0.
    % For KSID internal use only. Use fds_upgrade(fds) instead.

    assert(isstruct(fds));
    assert(isfield(fds, 'fdata'));
    assert(iscell(fds.fdata));

    flag = struct();
    flag.UAVmainframe = false;

    if size(fds.fdata, 1) < 4

        % old file must be UAVmainframe...
        flag.UAVmainframe = true;

        fdata(1,:) = fds.fdata(1,:);
        fdata(2,:) = fds.varlab;
        fdata(3,:) = fds.varunits;
        fdata(4,:) = fds.fdata(2,:);
        fds.fdata = fdata;

        fdataRows.Label = 1;
        fdataRows.Vars  = 2;
        fdataRows.Units = 3;
        fdataRows.Data  = 4;
        fds.fdataRows = fdataRows;

        fds.BoardSupportPackage = 'UAVmainframe';

    end

    assert(isfield(fds, 'fdataRows'));
    assert(isstruct(fds.fdataRows));
    assert(numel(fieldnames(fds.fdataRows)) == size(fds.fdata, 1));
    assert(isfield(fds.fdataRows, 'Label'));
    assert(isfield(fds.fdataRows, 'Vars'));
    assert(isfield(fds.fdataRows, 'Units'));
    assert(isfield(fds.fdataRows, 'Data'));

    if ~isfield(fds, 't')
        fds.t = fds_get_channel(fds, 'Base', 'Time') - fds_get_channel(fds, 'Base', 'Time', 1);
    end

    if ~isfield(fds, 'XLimit')
        fds.XLimit = [fds.t(1) fds.t(end)];
    end
    if ~isfield(fds, 'YLimit')
        fds.YLimit = [-100 100];
    end

    % Add time synchronization info
    if ~isfield(fds, 'offset')
        fds.offset = 0;
    end

    % Generate event list
    if flag.UAVmainframe
        if isfield(fds, 'config')
            fds.ACconfig = fds.config;
        else
            fds.ACconfig = [];
        end
        fds = UAVmainframe_event_list(fds);
    end

    % Upgrade event list
    if ~isfield(fds, 'event_list') || isempty(fds.event_list)
        fds.event_list = kVIS_fdsCreateEmptyEventList();
    elseif iscell(fds.event_list)
        EventList = kVIS_fdsCreateEmptyEventList();
        for I = 1 : size(fds.event_list, 1)
            K = numel(EventList) + 1;
            EventList(K).Type  = fds.event_list{I, 1};
            EventList(K).Start = fds.event_list{I, 2};
            EventList(K).End   = fds.event_list{I, 3};
            EventList(K).Plot  = fds.event_list{I, 4};
        end
        fds.event_list = EventList;
    end

    % Derive tree structure from data and labels
    if ~isfield(fds.fdataRows, 'Parent')
        % Derive structure from data and labels
        fds.fdata = [ fds.fdata; cell(1, size(fds.fdata, 2)) ];
        fds.fdataRows.Parent = size(fds.fdata, 1);
        root_node = 0;
        parent_node = root_node;
        for idx = 1 : size(fds.fdata, 2)
            node_name = fds.fdata{fds.fdataRows.Label, idx};
            node_is_category = isempty(fds.fdata{fds.fdataRows.Vars, idx});
            if node_is_category
                node_name = strip(strip(node_name, '='));
                fds.fdata{fds.fdataRows.Label, idx} = node_name;
                parent_node = root_node;
            end
            fds.fdata{fds.fdataRows.Parent, idx} = parent_node;
            if node_is_category
                parent_node = idx;
            end
        end
    end

    % Add TeX var labels field
    if ~isfield(fds.fdataRows, 'VarLabels_TeX')
        fds.fdata = [ fds.fdata; fds.fdata(fds.fdataRows.Vars, :) ];
        fds.fdataRows.VarLabels_TeX = size(fds.fdata, 1);
    end

    % Add tree state information
    if ~isfield(fds.fdataRows, 'GUIexpanded')
        fds.fdata = [ fds.fdata; cell(1, size(fds.fdata, 2)) ];
        fds.fdataRows.GUIexpanded = size(fds.fdata, 1);
        fds.fdata(fds.fdataRows.GUIexpanded, :) = {false};
    end
    if ~isfield(fds.fdataRows, 'GUIselected')
        fds.fdata = [ fds.fdata; cell(1, size(fds.fdata, 2)) ];
        fds.fdataRows.GUIselected = size(fds.fdata, 1);
        fds.fdata(fds.fdataRows.GUIselected, :) = {false};
    end

    % Determine array sizes
    fds.npoints = length(fds.t);
    fds.nfiles = size(fds.fdata,2);
    fds.nchnls = cellfun(@(x) size(x, 2), fds.fdata(fds.fdataRows.Data, :));

    % Update sample rate
    fds.SampleRate = 1/((fds.t(end) - fds.t(1))/length(fds.t));

    % Add BoardSupportPackage field
    if ~isfield(fds, 'BoardSupportPackage')
        fds.BoardSupportPackage = '';
    end
    
    if strcmp(fds.BoardSupportPackage, 'Lilium_Simulink')
        fds.BoardSupportPackage = 'Lilium_Phoenix';
    end

    fds.fdsVersion = 0;

end
