%
%> @file kVIS_showEvents_Callback.m
%> @brief Callback for show events button
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
%> @brief Callback for show events button
%>
%> @param GUI standard input 1
%> @param GUI standard input 2
%
function kVIS_showEvents_Callback(hObject, ~)

if hObject.Value == 0
    hObject.CData = imread('show_events.png');

    obj = findobj(gcbf(), 'Tag', 'EventDisplay');
    delete(obj);
else
    hObject.CData = imread('show_events_p.png')-10;

    axHandles = findobj(gcbf(), 'Type', 'axes');

    for I = 1:length(axHandles)

        kVIS_eventPlot(hObject, [], axHandles(I))

    end
end

end

