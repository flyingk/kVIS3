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

function kVIS_holdButton_Callback(hObject, ~, reset)

handles = guidata(hObject);

if reset == 1
    hObject.Value = 0;
end

if hObject.Value == 1
    hObject.CData = imread('icon_hold.png')-25;
    handles.uiFramework.holdToggle = 1;
elseif hObject.Value == 0
    hObject.CData = imread('icon_hold.png');
    handles.uiFramework.holdToggle = 0;
end

guidata(hObject, handles);

end

