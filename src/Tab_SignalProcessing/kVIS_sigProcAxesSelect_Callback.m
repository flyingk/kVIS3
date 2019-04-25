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

function kVIS_sigProcAxesSelect_Callback(hObject, ~, selection)

handles = guidata(hObject);

switch selection
    
    case 0
        
        handles.uiTabSigProc.axesFftLinearToggle.Value = 1;
%         handles.uiTabSigProc.axesFftLinearToggle.CData = imread('left_ax.png')-25;
        handles.uiTabSigProc.axesFftLogXToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogXToggle.CData = imread('right_ax.png');
        handles.uiTabSigProc.axesFftLogYToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogYToggle.CData = imread('top_ax.png');
        handles.uiTabSigProc.axesFftLogLogToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogLogToggle.CData = imread('top_ax.png');
        
        handles.uiTabSigProc.AxesSelector = @plot;
        
    case 1
        
        handles.uiTabSigProc.axesFftLinearToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLinearToggle.CData = imread('left_ax.png');
        handles.uiTabSigProc.axesFftLogXToggle.Value = 1;
%         handles.uiTabSigProc.axesFftLogXToggle.CData = imread('right_ax.png')-25;
        handles.uiTabSigProc.axesFftLogYToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogYToggle.CData = imread('top_ax.png');
        handles.uiTabSigProc.axesFftLogLogToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogLogToggle.CData = imread('top_ax.png');

        handles.uiTabSigProc.AxesSelector = @semilogx;
        
    case 2
        
        handles.uiTabSigProc.axesFftLinearToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLinearToggle.CData = imread('left_ax.png');
        handles.uiTabSigProc.axesFftLogXToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogXToggle.CData = imread('right_ax.png');
        handles.uiTabSigProc.axesFftLogYToggle.Value = 1;
%         handles.uiTabSigProc.axesFftLogYToggle.CData = imread('top_ax.png')-25;
        handles.uiTabSigProc.axesFftLogLogToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogLogToggle.CData = imread('top_ax.png');
        
        handles.uiTabSigProc.AxesSelector = @semilogy;
        
    case 3
        
        handles.uiTabSigProc.axesFftLinearToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLinearToggle.CData = imread('left_ax.png');
        handles.uiTabSigProc.axesFftLogXToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogXToggle.CData = imread('right_ax.png');
        handles.uiTabSigProc.axesFftLogYToggle.Value = 0;
%         handles.uiTabSigProc.axesFftLogYToggle.CData = imread('top_ax.png');
        handles.uiTabSigProc.axesFftLogLogToggle.Value = 1; 
%         handles.uiTabSigProc.axesFftLogLogToggle.CData = imread('top_ax.png')-25;

        handles.uiTabSigProc.AxesSelector = @loglog;
        
end

guidata(hObject, handles);

end