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

function [ ] = kVIS_generateCustomPlotM(figure_handle, fds, Ch, pts, Style)

DefaultStyle = struct();
DefaultStyle.Figure = struct();
DefaultStyle.Figure.Color = [0.3,0.4,0.58];
DefaultStyle.Axes = struct();
DefaultStyle.Axes.XColor = 'w';
DefaultStyle.Axes.YColor = 'w';
DefaultStyle.Axes.GridColor = 'k';
DefaultStyle.Axes.MinorGridColor = 'k';
DefaultStyle.Legend.FontSize = 12;
DefaultStyle.Legend.Location = 'northeast';

if isempty(Style)
    Style = DefaultStyle;
else
%     Style = KSID.Util.MergeStructs(Style, DefaultStyle);
end

kVIS_setGraphicsStyle(figure_handle, Style.Figure);

main_div = uix.VBox('Parent', figure_handle);

plts = uix.Grid('Parent', main_div);
ctrls= uix.HButtonBox('Parent', main_div, ...
    'Backgroundcolor', [0.3,0.4,0.58], ...
    'Spacing', 50, ...
    'HorizontalAlignment', 'right');

main_div.Heights = [-1 40];

% Create buttons
uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Hide legends', ...
    'Callback', @hide_all_legends_Callback ...
);

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Close', ...
    'Callback', @(src, event) close(gcbf()) ...
);

ctrls.ButtonSize = [100 30];

% Check plot definition.
% Columns:
%  1: Row
%  2: Col
%  3: AxesLayout
%  4: PlotStyle
%  5: Color
%  6: Group
%  7: Channel
%  8: ScaleFactor
%  9: UnitOverride
% 10: LabelOverride
assert(iscell(Ch) && size(Ch, 2) >= 9, 'Invalid plot definition');

if size(Ch, 2) < 10 % Column 10: LabelOverride
    Ch = [ Ch, Ch(:, 7) ]; % Copy Channel to LabelOverride (backwards compatibility)
end

NoOfPlotRows = max(cell2mat(Ch(:,1)));
NoOfPlotCols = max(cell2mat(Ch(:,2)));

oldpltindex=0;

for i = 1:size(Ch, 1)
    
    % get time vector
    tc = kVIS_fdsGetChannel(fds, Ch{i,6}, 'Time');
    
    % hotfix...
    if tc == -1
        disp('invalid plot def for this dataset...')
        continue
    end
    
    % get channel data
    [yp(:,i), meta] = kVIS_fdsGetChannel(fds, Ch{i,6}, Ch{i,7});
    
    if ~isstruct(meta)
        disp('invalid plot def for this dataset...')
        continue
    end
    
    label = meta.name;
    unit = meta.unit;

    label = meta.texName;

    % apply scale factor
    yp(:,i) = yp(:,i) * Ch{i,8};
    
    % unit override
    if ~isempty(Ch{i,9})
        unit(i) = Ch(i,9);
    end

    % LabelOverride
    if ~isempty(Ch{i, 10})
        label = getfield(ExtractInfoFromSignalName(Ch{i, 10}), 'TeX_Name');
    end

    % create plot index
    pltindex = (Ch{i,1}-1)*NoOfPlotCols+Ch{i,2};
    
    if pltindex == oldpltindex
        k=k+1;
    else
        k=1;
        clear p labelstr mm ma
        
        hh(pltindex) = uipanel('Parent', plts, 'Backgroundcolor', [0.3,0.4,0.58]);    
        ax = axes(hh(pltindex));
    end
    oldpltindex = pltindex;
    
    % axes style
    if Ch{i,3} == 'L'
        yyaxis left
    elseif Ch{i,3} == 'R'
        yyaxis right
    else
        % single plot
    end
    
    p(k) = plot(ax, tc, yp(:,i)); hold on
    p(k).LineWidth = 2.0;
    
    if ~isempty(Ch{i,4})
        p(k).LineStyle = Ch{i,4};
    end
    
    if ~isempty(Ch{i,5})
        p(k).Color = Ch{i,5};
    end
    
    labelstr{k} = sprintf('%s %s', label, unit);
    
    if k > 1
        legend_handle = legend(labelstr, 'Interpreter', 'latex');
        kVIS_setGraphicsStyle(legend_handle, Style.Legend);
        ylabel([])
    else
        ylabel(labelstr, 'Interpreter', 'latex');
    end

    for jj=1:k
        mm(jj) = min(p(jj).YData);
        ma(jj) = max(p(jj).YData);
    end
    
    mn = min(mm);
    mx = max(ma);
    
    if mn ~= mx
        ylim([mn-abs(mn*0.1) mx+abs(mx*0.1)])
    end
    
    xlim([tc(1) tc(end)])
    
    grid on
    xlabel('time')
    kVIS_setGraphicsStyle(gca, Style.Axes);
end

plts.Widths = ones(1, NoOfPlotCols)*-1;
plts.Heights = ones(1, NoOfPlotRows)*-1;

% find all axes handle of type 'axes' and empty tag
all_ha = findobj( figure_handle, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

end
