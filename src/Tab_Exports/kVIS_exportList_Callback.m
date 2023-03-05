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

function kVIS_exportList_Callback(hObject, ~)

% get GUI data
handles = guidata(hObject);


% get menu entry - plot selection
val = hObject.Value;

exportName = hObject.String{val};

% edit the plot definition file, if selected
if handles.uiTabExports.editExportDefBtn == 1
    
    BSP_Path = getpref('kVIS_prefs','bspDir');
    BSP_Exports_Path = fullfile(BSP_Path, 'Exports');
    
    if (ismac)
        cmdstr = ['open ' BSP_Exports_Path '/' exportName];
        
        rc = system(cmdstr);
    elseif (ispc)
        winopen([BSP_Exports_Path '\' exportName]);
        rc = 0;
    else
        disp('Platform not supported!');
        return
    end
    
    if rc ~= 0
        disp('Export definition file (.xlsx) not found. Opening folder instead...')
        cmdstr = ['open ' BSP_Exports_Path];
        system(cmdstr);
    end
    
    kVIS_editExportDefBtn_Callback(findobj('Tag','editExportDefBtn'), [], 1)
    
    return
end


try
    fds = kVIS_getCurrentFds(hObject);
catch
    disp('No fds loaded. Abort.')
    return;
end

%
% Read export definition
%
ExportDefinition = handles.uiTabExports.Exports;

file = [ExportDefinition.BSP_Exports_Path '/' exportName];

if endsWith(file,".xlsx")
    [~,~,ExportDefinition] = xlsread(file,'','','basic');
end

ExportDef = ExportDefinition(6:end,:);

% Columns:
exportNo = 1;
channel = 2;
scaleFactor = 3;
fcnHandle = 4;
fcnChannel = 5;
labelOverride = 6;
unitOverride = 7;

nExports = max(cell2mat(ExportDef(:,exportNo)));

exportData = [];

for I = 1: nExports
    
    % get data
    ChanID = strsplit(ExportDef{I, channel}, '/');
    [yp, yMeta] = kVIS_fdsGetChannel(fds, ChanID{1}, ChanID{2});
    
    if yp == -1
        disp('y channel not found... Skipping.')
        continue;
    end
    
    % init output structure with correct length
    if isempty(exportData)
        exportData = zeros(length(yp), nExports);
    end
    
    % apply scale factor
    yp = yp * ExportDef{I,scaleFactor};
    
    % apply function to data
    if ~isnan(ExportDef{I,fcnHandle})

        try
            yp = feval(ExportDef{I,fcnHandle}, yp, fds, [], ExportDef{I,fcnChannel});

        catch ME
            ME.identifier
            disp('Function eval error... Ignoring.')
            error = 1;
            return
        end
    end
    
    % ensure data is not complex
    if ~isreal(yp)
        disp('complex magic :( converting to real...')
        yp = real(yp);
    end
    
    % LabelOverride
    if ~isnan(ExportDef{I, labelOverride})
        yMeta.dispName = ExportDef{I, labelOverride};
    end
    
    % UnitOverride
    if ~isnan(ExportDef{I, unitOverride})
        yMeta.unit = ExportDef{I, unitOverride};
    end

    exportData(:,I) = yp;
    
    if strcmp(yMeta.unit, '-') || strcmp(yMeta.frame, '-')
        
        exportLabels{:,I} = yMeta.name;
        
    else
    
        if ~isempty(yMeta.frame) && ~isempty(yMeta.unit)
            exportLabels{:,I} = [yMeta.dispName '_UNIT_' yMeta.unit '_FRAME_' yMeta.frame];
            
        elseif ~isempty(yMeta.unit)
            exportLabels{:,I} = [yMeta.dispName '_UNIT_' yMeta.unit];
            
        else
            exportLabels{:,I} = yMeta.dispName;
        end

    end
    
    
end


% export full data length
if handles.uiTabExports.exportsUseLimitsBtn == 1
    
    exportRange = kVIS_getDataRange(hObject, 'XLim');
    
    timeVec = exportData(:,1);
    locs = find(timeVec > exportRange(1) & timeVec < exportRange(2));
    
    exportData = exportData(locs,:);
end


%
% snapshot
%
if handles.uiTabExports.exportsSnapshotsBtn == 1
    %
    % select point
    %
    [x,~] = ginput(1);
    x = round(x*100)/100;
    %
    % specify time range to average
    %
    answerAverages = inputdlg({'Time interval to average [sec]:'},'',1,{'0.01'});
    answerAverages = str2double(answerAverages);
    exportRange = [x-answerAverages/2 x+answerAverages/2];
    
    timeVec = exportData(:,1);
    locs = find(timeVec > exportRange(1) & timeVec < exportRange(2));
    if isempty(locs)
        disp('selected interval contains no sample')
        return
    end
    exportData = mean(exportData(locs,:),1);
end
%
% export format: default CSV
%
answerFormat = questdlg('Export format', '', 'Matrix', 'Vectors', 'CSV', 'CSV');
%
% save file
%
switch answerFormat
    
    case 'Matrix'
        
        assignin('base', 'exportLabels', exportLabels)
        assignin('base', 'exportData', exportData)
        
    case 'Vectors'
    
    case 'CSV'
        % select file name
        [file,path] = uiputfile('export.csv','Save file name');
        
        if file == 0
            return
        end
        
        % write header with channel labels
        fileID = fopen(fullfile(path,file), 'w');
        
        for I = 1:length(exportLabels)
            fprintf(fileID,'%s',exportLabels{I});
            if I < length(exportLabels)
                fprintf(fileID,',');
            else
                fprintf(fileID,'\n');
            end
        end
        
        fclose(fileID);
        
        % write data
        dlmwrite(fullfile(path,file), exportData, '-append','precision',8)
end

end

