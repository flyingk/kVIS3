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
        
        if isfield(line.UserData, 'HighlightState') && length(line.UserData.HighlightState) > 1
            line.LineWidth = 1;
            line.Color = line.UserData.HighlightState;
            line.Marker = 'none';
            line.LineStyle = '-';
            line.UserData.HighlightState = false;
        else
            answ = inputdlg({'Line colour ( Matlab letter codes )','Line Style [-|--|:|-.|none]','Line Width','Marker'},'Format line', 1, {'r','-','2','none'});
            if ~isempty(answ)
                % save state
                line.UserData.HighlightState = line.Color;
                % format line
                line.Color = answ{1};
                line.LineStyle = answ{2};
                line.LineWidth = str2double(answ{3});
                line.Marker = answ{4};
            end
            
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
            
            if isfield(line.UserData,'timeOffset')
                line.UserData.timeOffset = line.UserData.timeOffset + str2double(answ);
            else
                line.UserData.timeOffset = str2double(answ);
            end
            
            line.DisplayName = [line.DisplayName ' dT (' num2str(line.UserData.timeOffset) 's)'];
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
        % Display signal statistics
        %
    case 'Signal statistics'
        
        % Get axes properties
        ax = line.Parent;
        hold(ax, 'on');
        xlims = ax.XAxis.Limits;
        a = lines;

        % Extract applicable line data
        t = line.XData;
        locs = (t>min(xlims)) & (t<max(xlims));
        y = line.YData(locs);
        
        % Get properties
        m = mean(y);
        sd= std(y);
        
        % Remove old lines
        if isfield(line.UserData,'Stats')
            if isfield(line.UserData.Stats,    'mean'); delete(line.UserData.Stats.mean    ); end
            if isfield(line.UserData.Stats,'Sigma1Up'); delete(line.UserData.Stats.Sigma1Up); end
            if isfield(line.UserData.Stats,'Sigma2Up'); delete(line.UserData.Stats.Sigma2Up); end
        end
        
        % Plot stats data      
        pg = polyshape([xlims(1) xlims(2) xlims(2) xlims(1)],[m+sd*2 m+sd*2 m-sd*2 m-sd*2]);
        line.UserData.Stats.Sigma2Up = plot(ax, pg, 'FaceColor', 'yellow', 'EdgeColor', 'none'); % 2 sigma
        line.UserData.Stats.Sigma2Up.DisplayName = '2 sigma';
        uistack(line.UserData.Stats.Sigma2Up,'down')
        
        pg = polyshape([xlims(1) xlims(2) xlims(2) xlims(1)],[m+sd m+sd m-sd m-sd]);
        line.UserData.Stats.Sigma1Up = plot(ax, pg, 'FaceColor', 'green', 'EdgeColor', 'none'); % 1 sigma
        line.UserData.Stats.Sigma1Up.DisplayName = 'sigma';
        uistack(line.UserData.Stats.Sigma1Up,'down')
        
        line.UserData.Stats.mean = plot(ax, xlims, ones(2,1)*m     ,'-' ,'color',a(2,:),'lineWidth',line.LineWidth*2.0); % mean
        line.UserData.Stats.mean.DisplayName = 'mean';
        uistack(line.UserData.Stats.mean,'down')
        
        title(ax,{['Mean: ' num2str(m)],['Std Dev: ' num2str(sd)]}, 'Color', 'w');
        
        kVIS_axesResizeToContainer(ax);
        
        %
        % Signal uncertainty as shaded area
        % 
    case 'Signal uncertainty'
        
        % Get axes properties
        ax = line.Parent;
        hold(ax, 'on');
%         xlims = ax.XAxis.Limits;
%         a = lines;
        
        % get line data as column vector
        y = line.YData';
        c = line.Color;
        
        % ask for desired operation
        answ = inputdlg({'Constant uncertainty:','Optional uncertainty channel (group/channel):'},...
            'Line data uncertainty', 1, {'1',''});
        
        if ~isempty(answ)
            
            % second channel as operator?
            if ~isempty(answ{2})
                fds = kVIS_getCurrentFds(source);
                zChanID = strsplit(answ{2}, '/');
                [uncert, meta] = kVIS_fdsGetChannel(fds, zChanID{1}, strip(zChanID{2}));
                
                if uncert == -1
                    disp('y channel not found... Skipping.')
                    return
                end
                
                t = line.XData; % must account for different t vec later...
            else
                t = line.XData;
                uncert = str2double(answ{1});
            end
            
            % need to reduce sample numbers, otherwise fill() is very
            % slow...
            x_vector = kVIS_downSample([t'; flipud(t')], 10);
            y_vector = kVIS_downSample([y+uncert; flipud(y-uncert)], 10);
            
            patch = fill(x_vector, y_vector, c);
            set(patch, 'edgecolor', c);
            set(patch, 'FaceAlpha', 0.3);
            patch.DisplayName = 'Uncertainty';
            uistack(patch, 'down')
            
        else
            % do nothing
            return
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
