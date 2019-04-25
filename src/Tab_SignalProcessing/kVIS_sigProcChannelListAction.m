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

function kVIS_sigProcChannelListAction(hObject)
%
%  Plot the selected column of fdata.
%
handles=guidata(hObject);

% Load signal data.
[signal, signalMeta] = kVIS_fdsGetCurrentChannel(hObject);

% get selected range
xRange = kVIS_getDataRange(hObject, 'XLim');
locs = find(signalMeta.timeVec >= xRange(1) & signalMeta.timeVec <= xRange(2));

signal = signal(locs);
signalMeta.timeVec = signalMeta.timeVec(locs);

% plot the signal into the specified axes
kVIS_plotSignal( ...
    hObject, ...
    signal, signalMeta, ...
    handles.uiFramework.holdToggle, ...
    handles.uiTabSigProc.axesLeft, ...
    @plot ...
    );

% fft plot, replace timevec with freq vector
% remove signal mean ...
[p, signalMeta.timeVec] = spect(signal-mean(signal), signalMeta.timeVec, [0.01:0.01:50]*2*pi, 10, 0, 0);

kVIS_plotSignal( ...
    hObject, ...
    p, signalMeta, ...
    handles.uiFramework.holdToggle, ...
    handles.uiTabSigProc.axesRight, ...
    handles.uiTabSigProc.AxesSelector ...
    );
end