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

function kVIS_plotLineContextMenuActions_Callback(source, ~, line)
%
% provide functionality to modify a plot line
%

if ~isstruct(line.UserData)
    disp('No line data available...')
    return
end

switch source.Label
    %
    % change line thickness
    %
    case 'Highlight'
        if isfield(line.UserData, 'HighlightState') && line.UserData.HighlightState
            line.LineWidth = 0.5;
            line.UserData.HighlightState = false;
        else
            line.LineWidth = 2.5;
            line.UserData.HighlightState = true;
        end
        
    %
    % apply a math operation to the line data
    %
    case 'Modify'
        
        % get line data as column vector
        y = line.YData';
        
        % ask for desired operation
        answ = inputdlg({'Matlab expression ( y = line data ):','Optional operator channel (group/channel) ( z variable ):'},...
            'Line data math operation', 1, {'y',''});
        
        if ~isempty(answ)
            
            % save state to restore
            line.UserData.dataBackup = y';
            line.UserData.nameBackup = line.DisplayName;
            line.UserData.colorBackup = line.Color;
            line.UserData.modState = true;
            
            % second channel as operator?
            if ~isempty(answ{2})
                fds = kVIS_getCurrentFds(source);
                zChanID = strsplit(answ{2}, '/');
                z = kVIS_fdsGetChannel(fds, zChanID{1}, strip(zChanID{2}));
                
                if z == -1
                    disp('y channel not found... Skipping.')
                    return
                end
            end
            
            %
            % evaluate requested expression
            %
            res = eval(answ{1});
            
            %
            % update line - change color and name to indicate modifcation
            %
            line.YData = res;
            line.LineStyle = '-';
            line.Color = 'm';
            
            line.DisplayName = [line.DisplayName '_MOD_(' answ{1} ')'];
               
        else
            % do nothing
            return
        end
    
    %
    % undo line math operation
    %
    case 'Undo modify'
        
        if line.UserData.modState == true
        
            line.YData = line.UserData.dataBackup;
            line.DisplayName = line.UserData.nameBackup;
            line.Color = line.UserData.colorBackup;
            line.UserData.modState = false;
        end
        
    %
    % delete the line
    %
    case 'Delete'
        delete(line);
    otherwise
        warning('Unknown action: %s', source.Label);
end

end
