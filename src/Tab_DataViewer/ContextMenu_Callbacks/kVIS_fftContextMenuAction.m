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

function kVIS_fftContextMenuAction(hObject, ~, ax)

switch hObject.Label
    
    case 'Force Update'

        kVIS_fftUpdate([], []);
    
    case 'linear'
        
        ax.XScale = 'linear';
        ax.YScale = 'linear';
        
    case 'log x'
        
        ax.XScale = 'log';
        ax.YScale = 'linear';
        
            case 'log y'
        
        ax.XScale = 'linear';
        ax.YScale = 'log';
        
    case 'loglog'
        
        ax.XScale = 'log';
        ax.YScale = 'log';
        
    case 'Set Frequency Range'
        
        answ = inputdlg({'Min. Freq. [Hz]', 'Max. Freq. [Hz]'}, 'PSD Frequency Range', 1, {num2str(0.01), num2str(5)});
        
        if isempty(answ)
            return
        else
            % set fft range in panel property
            ax.Parent.fftRange(1) = str2double(answ(1));
            ax.Parent.fftRange(2) = str2double(answ(2));
            kVIS_fftUpdate([], []);
        end
        
end

end

