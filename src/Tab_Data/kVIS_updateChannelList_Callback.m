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

function kVIS_updateChannelList_Callback(hObject, ~, nameSelect)

handles = guidata(hObject);
%
% Get file number
%
if isempty(handles.uiTabData.groupTree.SelectedNodes)
    set(handles.uiTabData.channelListbox,'Value',0);
    set(handles.uiTabData.channelListbox,'String',{});
    return
else
    fileNo = handles.uiTabData.groupTree.SelectedNodes.Value;
end

kVIS_fdsUpdateSelectionInfo(hObject, []);

[ fds, ~ ] = kVIS_getCurrentFds(hObject);

%
%  Get the variable labels and units.
%
if nameSelect == 0
    handles.uiTabData.channelListBoxMenu1.Checked = 'on';
    handles.uiTabData.channelListBoxMenu2.Checked = 'off';
    vars = fds.fdata{fds.fdataRows.varNamesDisp, fileNo};
    
    units = fds.fdata{fds.fdataRows.varUnits, fileNo};
    frames = fds.fdata{fds.fdataRows.varFrames, fileNo};
    
    %
    % decode channel name string if appropriate
    %
    for k=1:length(units)
        if contains(vars{k}, 'UNIT') || contains(vars{k}, 'FRAME')
            [ SignalInfo ] = kVIS_extractInfoFromSignalName( vars{k} );
            vars{k}   = SignalInfo.DispName;
            units{k}  = SignalInfo.Data.Unit;
            frames{k} = SignalInfo.Data.Frame;
        else
        end
    end
    
else
    handles.uiTabData.channelListBoxMenu1.Checked = 'off';
    handles.uiTabData.channelListBoxMenu2.Checked = 'on';
    vars = fds.fdata{fds.fdataRows.varNames, fileNo};
    units = fds.fdata{fds.fdataRows.varUnits, fileNo};
    frames = fds.fdata{fds.fdataRows.varFrames, fileNo};
end


if ~isempty(vars)
    vars = cellfun(@(x) sprintf('  %s', x), vars, 'UniformOutput', false);
end

if isempty(frames)
    frames = cell(size(units));
    frames = cellfun(@(x) sprintf(''), frames, 'UniformOutput', false);
end
%
%  Mark the channels that have been assigned.
%
varlist = {};

% % Print error message if not enough var name/unit fields available
% data_type = evalin('base',['fds.fdata(1,',num2str(ff,'%.d'),');']);
% data_type = data_type{1};
% expected_fields = n(ff);
% loaded_var_names = length(vars);
% loaded_var_units = length(units);
%
% if (expected_fields > loaded_var_names)
%     clc
%     fprintf('\n\nIn %s data type - have %d of %d variable name fields.  Filling it out so it still works...\n',data_type,loaded_var_names,expected_fields);
%     warning('Fix up the var names in UAVmainframe_5_0.m');
%     % Fill out vars to make it long enough
%     for ii = 1:(expected_fields-loaded_var_names)
%         vars{end+1,1} = '  FIX ME NAME!';
%     end
% end
% if (expected_fields > loaded_var_units)
%     clc
%     fprintf('\n\nIn %s data type - have %d of %d variable unit fields  Filling it out so it still works...\n',data_type,loaded_var_units,expected_fields);
%     warning('Fix up the var units in UAVmainframe_5_0.m')
%     % Fill out units to make it long enough
%         for ii = 1:(expected_fields-loaded_var_units)
%         units{end+1,1} = '  FIX ME UNITS!';
%         end
% end
%
% % Check for too many fields, means running out of data software...
% if (expected_fields<max(loaded_var_names,loaded_var_units))
%     fprintf('\n\n%s data type\n',data_type);
%     warning('Too many var names/units loaded, probably means you''re running an out-of-date UAVmainframe')
% end

varlist = cell(fds.fdataAttributes.nChnls(fileNo), 1);

for i=1:fds.fdataAttributes.nChnls(fileNo)
    
    % mark non-zero channels
    if any(fds.fdata{fds.fdataRows.data, fileNo}(:,i)) ~= 0
        vars = mrk_chnl(vars,i);
    end
    
    %
    %  Include SIDPAC channel numbers, and line up the display.
    %
    if nameSelect == 0
        
        if isempty(char(units(i)))
            if i < 10
                varlist(i)=cellstr([num2str(i),'  ',char(vars(i))]);
            elseif i < 100
                varlist(i)=cellstr([num2str(i),' ',char(vars(i))]);
            else
                varlist(i)=cellstr([num2str(i),'',char(vars(i))]);
            end
        elseif isempty(char(frames(i)))
            if i < 10
                varlist(i)=cellstr([num2str(i),'  ',char(vars(i)),' (',char(units(i)),')']);
            elseif i < 100
                varlist(i)=cellstr([num2str(i),' ',char(vars(i)),' (',char(units(i)),')']);
            else
                varlist(i)=cellstr([num2str(i),'',char(vars(i)),' (',char(units(i)),')']);
            end
            
        else
            if i < 10
                varlist(i)=cellstr([num2str(i),'  ',char(vars(i)),' (',char(units(i)),') (',char(frames(i)),')']);
            elseif i < 100
                varlist(i)=cellstr([num2str(i),' ',char(vars(i)),' (',char(units(i)),') (',char(frames(i)),')']);
            else
                varlist(i)=cellstr([num2str(i),'',char(vars(i)),' (',char(units(i)),') (',char(frames(i)),')']);
            end
        end
        
    else
        if i < 10
            varlist(i)=cellstr([num2str(i),'  ',char(vars(i))]);
        elseif i < 100
            varlist(i)=cellstr([num2str(i),' ',char(vars(i))]);
        else
            varlist(i)=cellstr([num2str(i),'',char(vars(i))]);
        end
        
    end
end

%
%  Update the listbox.
%
set(handles.uiTabData.channelListbox,'Value',1);
set(handles.uiTabData.channelListbox,'String',varlist);

end

function mlab = mrk_chnl(lab,n)
%
%  Mark or clear the nth channel.
%
mlab=lab;
if n > 0
    name=char(lab(n));
    name(1)='*';
    mlab(n)=cellstr(name);
else
    n=abs(n);
    name(1)=' ';
    mlab(n)=cellstr(name);
end
return

end
