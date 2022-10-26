%
%> @file kVIS_CustomPlotShowEvents_Callback.m
%> @brief Callback for show events button in custom plot figures
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
%> @brief Callback for show events button in custom plot figures
%>
%> @param GUI standard input 1
%> @param GUI standard input 2
%
function kVIS_CustomPlotShowEvents_Callback(hObject, ~)

fig = gcbf;

if hObject.Value == 0

    obj = findobj(gcbf(), 'Tag', 'EventDisplay');
    delete(obj);

else

    MainWindowHandle = fig.UserData.MainWindowHandle;

    axHandles = findobj(gcbf(), 'Tag', 'Xaxislink');

    for I = 1:length(axHandles)

        kVIS_eventPlot(MainWindowHandle, [], axHandles(I), [])

    end
end

end
