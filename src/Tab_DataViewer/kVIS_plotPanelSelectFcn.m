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

function kVIS_plotPanelSelectFcn(hObject, ~)

handles = guidata(hObject);

if strcmp(hObject.Tag, 'fftPanel')
    return
end

%
% previously selected panel
%
l = findobj('Tag', 'plotPanel_active');
%
% link fft plot, if created previously
%
if strcmp(l.UserData.PlotType, 'fft') && isempty(l.UserData.fftLink)
    
    l.UserData.fftLink = hObject;
    
    ax = hObject.Children;
    
    l.UserData.listener = addlistener(ax,'UserData','PostSet',@kVIS_fftUpdate);
    
    l.BackgroundColor = 'c'; %handles.preferences.uiBackgroundColour + [0.15 0 0.15];
    l.Tag = 'fftPanel';
    
    kVIS_fftUpdate([],[])
    
else
    
    l.BackgroundColor = handles.preferences.uiBackgroundColour;
    l.Tag = 'plotPanel';
    
end
%
% set selected plot active
%
hObject.BackgroundColor = handles.preferences.uiBackgroundColour + 0.15;
hObject.Tag = 'plotPanel_active';

end