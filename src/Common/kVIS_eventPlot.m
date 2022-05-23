%
%> @file kVIS_eventPlot.m
%> @brief Add event boundaries to a selected plot
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
%> @brief Add event boundaries to a selected plot
%>
%> @param GUI standard input 1
%> @param GUI standard input 2
%> @param Custom plot axes handle
%
function kVIS_eventPlot(MainWindowObject, ~, axesHandle)

handles=guidata(MainWindowObject);


%     if ~isempty(handles.uiTabDataViewer.showEvents)
%         h = handles.uiTabDataViewer.showEvents;
%         delete(h)
%     end

%
% selected axes
%
if isempty(axesHandle)
    targetPanel = kVIS_dataViewerGetActivePanel();
    axes_handle = targetPanel.axesHandle;
else
    axes_handle = axesHandle;
end

hold(axes_handle, 'on');

ylim = kVIS_getDataRange(MainWindowObject, 'YLim');

if isnan(ylim)
    %     current_lines = kVIS_findValidPlotLines(axes_handle);
    %
    %     ylim(1) = min(arrayfun(@(x) x.UserData.yMin, current_lines));
    %     ylim(2) = max(arrayfun(@(x) x.UserData.yMax, current_lines));

    ylim = axes_handle.YLim;
end

fds = kVIS_getCurrentFds(MainWindowObject);

eventList = fds.eventList;

if isempty(eventList)
    errordlg('kVIS_eventPlot: event list empty...')
    return
end

for j = 1:size(eventList,2)

    % relate times to samples
    in = eventList(j).start;
    out= eventList(j).end;

    % create plot
    pg = polyshape([in out out in],[ylim(1) ylim(1) ylim(2) ylim(2)]);

    pp(j) = plot(axes_handle, pg, ...
        'EdgeAlpha',0.4,...
        'FaceAlpha',0.2);

    % use context menu for labels
    m = uicontextmenu();
    uimenu('Parent', m, 'Label', sprintf('%s: %s', eventList(j).type, eventList(j).description), 'Enable', 'off');

    pp(j).UIContextMenu = m;
    pp(j).DisplayName = eventList(j).type;

    % custom plot don't add to legend
    if ~isempty(axesHandle)
        pp(j).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end

    % Add a label to each of the plots based on the name of the event
    eventName = [eventList(j).type,' '];
    text(axes_handle, out,ylim(2),eventName,'Rotation',90,'FontSize',8, ...
        'VerticalAlignment','bottom','HorizontalAlignment','right');
end

% not a custom plot ?
if isempty(axesHandle)

    handles.uiTabDataViewer.showEvents = pp;

    guidata(MainWindowObject, handles);
end

end