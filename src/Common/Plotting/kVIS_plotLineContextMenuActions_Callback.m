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
            answ = inputdlg('New Line colour ( Matlab letter code )');
            if ~isempty(answ)
                line.Color = answ{1};
            end
            line.LineWidth = 2.0;
            line.UserData.HighlightState = true;
        end
        %
        % apply filter to line data
        %
    case 'Apply Filter'
        % get line data as column vector
        y = line.YData';
        fs = line.UserData.signalMeta.sampleRate;
        
        % ask for desired operation
        answ = inputdlg({'Cut-off Frequency [Hz]:','Low/Highpass [0/1]:'},...
            'Filter settings', 1, {'2','0'});
        
        if ~isempty(answ)
            
            % save state to restore
            line.UserData.dataBackup = y';
            line.UserData.nameBackup = line.DisplayName;
            line.UserData.colorBackup = line.Color;
            line.UserData.modState = true;
            
            %
            % evaluate requested expression
            %
            res = fdfilt(y, str2double(answ(1)), 1/fs, str2double(answ(2)));
            
            %
            % update line - change color and name to indicate modifcation
            %
            line.YData = res;
            line.LineStyle = '-';
            %             line.Color = 'm';
            
            line.DisplayName = [line.DisplayName ' Filt (' answ{1} ' Hz)'];
            if ~isempty(line.Parent.YLabel.String)
                line.Parent.YLabel.String = line.DisplayName;
            end
            
        else
            % do nothing
            return
        end
        
        %
        % differentiate line data
        %
    case 'Differentiate'
        % get line data as column vector
        y = line.YData';
        fs = line.UserData.signalMeta.sampleRate;
        
        
        % save state to restore
        line.UserData.dataBackup = y';
        line.UserData.nameBackup = line.DisplayName;
        line.UserData.colorBackup = line.Color;
        line.UserData.modState = true;
        
        %
        % evaluate requested expression
        %
        res = deriv(y, 1/fs);
        
        %
        % update line - change color and name to indicate modifcation
        %
        line.YData = res;
        line.LineStyle = '-';
        
        line.DisplayName = [line.DisplayName ' dot'];
        if ~isempty(line.Parent.YLabel.String)
            line.Parent.YLabel.String = line.DisplayName;
        end
        
        %
        % integrate line data
        %
    case 'Integrate'
        % get line data as column vector
        y = line.YData';
        fs = line.UserData.signalMeta.sampleRate;
        
        % ask for desired operation
        answ = inputdlg({'Initial Value:'},...
            'Euler Integration', 1, {'0'});
        
        if ~isempty(answ)
            
            % save state to restore
            line.UserData.dataBackup = y';
            line.UserData.nameBackup = line.DisplayName;
            line.UserData.colorBackup = line.Color;
            line.UserData.modState = true;
            
            %
            % evaluate requested expression
            %
            res = zeros(length(y),1);
            res(1) = str2double(answ(1));
            for j = 1:length(y)-1
                res(j+1) = res(j) + y(j)*(1/fs);
            end
            %
            % update line - change color and name to indicate modifcation
            %
            line.YData = res;
            line.LineStyle = '-';
            %             line.Color = 'm';
            
            line.DisplayName = [line.DisplayName ' Int(t)'];
            if ~isempty(line.Parent.YLabel.String)
                line.Parent.YLabel.String = line.DisplayName;
            end
            
        else
            % do nothing
            return
        end
        
        %
        % apply a math operation to the line data
        %
    case 'Apply Custom Operation'
        
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
            %             line.Color = 'm';
            
            line.DisplayName = [line.DisplayName ' MOD (' answ{1} ')'];
            if ~isempty(line.Parent.YLabel.String)
                line.Parent.YLabel.String = line.DisplayName;
            end
            
        else
            % do nothing
            return
        end
        
        %
        % apply time shift
        %
    case 'Apply time offset'
        
        % get line data as column vector
        t = line.XData';
        
        % ask for desired operation
        answ = inputdlg({'Time offset:'},'Apply time offset [sec]', 1, {'0.0'});
        
        if ~isempty(answ)
            
            % save state to restore
            line.UserData.timeBackup = t';
            line.UserData.nameBackup = line.DisplayName;
            line.UserData.colorBackup = line.Color;
            line.UserData.modState = true;
            
            line.XData = t + str2double(answ);
            
        end
        
        %
        % undo line math operation
        %
    case 'Undo modify'
        
        if line.UserData.modState == true
            
            if isfield(line.UserData,'timeBackup')
                line.XData = line.UserData.timeBackup;
            end
            
            if isfield(line.UserData,'dataBackup')
                line.YData = line.UserData.dataBackup;
            end
            
            line.DisplayName = line.UserData.nameBackup;
            line.Color = line.UserData.colorBackup;
            line.UserData.modState = false;
            if ~isempty(line.Parent.YLabel.String)
                line.Parent.YLabel.String = line.DisplayName;
            end
        end
        
        %
        % Export line to workspace
        %
    case 'Export to workspace'
        
        y = line.YData;
        
        answ = inputdlg('Variable name:');
        
        assignin('base', answ{1}, y)
        
        %
        % Send line back in stack
        %
    case 'Send Back'
        uistack(line, 'down');
        
        %
        % delete the line
        %
    case 'Delete'
        delete(line);
    otherwise
        warning('Unknown action: %s', source.Label);
end

end
