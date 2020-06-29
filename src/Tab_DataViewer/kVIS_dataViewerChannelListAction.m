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

function kVIS_dataViewerChannelListAction(hObject)

%
% selected axes
%
targetPanel = kVIS_dataViewerGetActivePanel();

if isempty(targetPanel)
    errordlg('No plot selected...')
    return
end

%
% update map plot
%
if strcmp(targetPanel.Tag, 'mapplot')
    
    h = findobj(targetPanel.axesHandle, 'Type', 'Scatter');
    
    if isempty(h)
        errordlg('Map has been cleared. Select ''timeplot'' to plot data or re-create map.')
        return
    end
    
    kVIS_updateMap(hObject, h)
    
elseif strcmp(targetPanel.Tag, 'timeplot')
    %
    %  Plot the selected column of fdata.
    %
    handles=guidata(hObject);
    
    % Load signal data.
    [signal, signalMeta] = kVIS_fdsGetCurrentChannel(hObject);
    
    %
    % plot the signal into the specified axes
    %
    kVIS_plotSignal( ...
        hObject, ...
        signal, signalMeta, ...
        handles.uiFramework.holdToggle, ...
        targetPanel.axesHandle, ...
        @plot ...
        );
    
    targetPanel.plotChanged = randi(1000);
    
    evplot(hObject);
    
end

end



function evplot(hObject)

handles=guidata(hObject);

% event display testing
et = findobj('Tag','showEventsToggle');

if et.Value == 1
    
    if ~isempty(handles.uiTabDataViewer.showEvents)
        h = handles.uiTabDataViewer.showEvents;
        delete(h)
    end
    
    %
    % selected axes
    %
    targetPanel = kVIS_dataViewerGetActivePanel();
    axes_handle = targetPanel.axesHandle;
    
    hold(axes_handle, 'on');
    
    ylim = kVIS_getDataRange(hObject, 'YLim');
    if isnan(ylim)
        current_lines = kVIS_findValidPlotLines(axes_handle);
        
        ylim(1) = min(arrayfun(@(x) x.UserData.yMin, current_lines));
        ylim(2) = max(arrayfun(@(x) x.UserData.yMax, current_lines));
    end
    
    fds = kVIS_getCurrentFds(hObject);
    
    eventList = fds.eventList;
    
    if isempty(eventList)
        disp('kVIS_dataViewerChannelListAction: event list empty...')
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
%         pp(j).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    handles.uiTabDataViewer.showEvents = pp;
    
    guidata(hObject, handles);
end

end