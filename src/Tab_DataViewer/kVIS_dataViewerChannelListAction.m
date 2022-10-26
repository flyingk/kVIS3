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
    lineColor = [];
    lineStyle = [];
    xLbl    = 'Time [sec]';
    yLbl    = kVIS_generateLabels(signalMeta, []);
    xLimits = kVIS_getDataRange(hObject, 'XLim');
    yLimits = kVIS_getDataRange(hObject, 'YLim');
    interactiveToggle = true;

    kVIS_plotSignal2(targetPanel.axesHandle, @plot, ...
        signalMeta.timeVec, [], ...
        signal, signalMeta, ...
        lineColor, lineStyle, ...
        xLbl, yLbl, ...
        xLimits, yLimits, ...
        handles.uiFramework.holdToggle, ...
        handles.uiTabDataViewer.plotStyles, ...
        interactiveToggle ...
        );

    targetPanel.plotChanged = randi(1000);
    kVIS_axesResizeToContainer(targetPanel.axesHandle);
    targetPanel.axesHandle.XRuler.Exponent = false; % no exp in time stamps
end

end



