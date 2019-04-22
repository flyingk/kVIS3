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

function generate_all_custom_plots_Callback(hObject, ~)

    handles = guidata(hObject);

    try
        fds = get_current_fds(handles);
    catch err
        % No fds loaded
        errordlg('No fds loaded...')
        return;
    end

    if isempty(fds.BoardSupportPackage)
        %errordlg('fds.BoardSupportPackage not defined');
        AvailableBSP_List = fieldnames(handles.CustomPlots);
        [ BSP_Selection_Idx, Status ] = listdlg( ...
            'ListString', AvailableBSP_List, ...
            'SelectionMode', 'single', ...
            'Name', 'Generate custom plots ...', ...
            'PromptString', 'Select custom plots to generate' ...
        );
        if ~Status
            return;
        end
        BSP_Name = AvailableBSP_List{BSP_Selection_Idx};
    else
        BSP_Name = fds.BoardSupportPackage;
    end

    if ~isfield(handles.CustomPlots, BSP_Name)
        errordlg('No custom plots defined for BSP %s', BSP_Name);
        return;
    end

    OutputDirectory = uigetdir();
    if ~OutputDirectory
        return;
    end

    PlotDefinition_List = handles.CustomPlots.(BSP_Name);
    PlotsToBeCreated = fieldnames(PlotDefinition_List);
    for I = 1 : numel(PlotsToBeCreated)
        PlotDefinition = PlotDefinition_List.(PlotsToBeCreated{I});
        FigureName = PlotsToBeCreated{I};
        % try/catch in case some plots fail due to changed signal names etc.
        try
            FigureHandle = KSID.API.CustomPlots.Create(fds, PlotDefinition, 'Name', FigureName);
            saveas(FigureHandle, fullfile(OutputDirectory, [FigureName, '.fig']));
            close(FigureHandle);
        catch Exception
            disp(Exception.getReport('extended', 'hyperlinks', 'on'));
            errordlg(Exception.getReport('basic', 'hyperlinks', 'off'));
        end
    end

end
