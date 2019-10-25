function kVIS_fdsImportDataGroup(hObject, ~)
%
% Import data from csv file and add to current fds tree
%

[fds, name] = kVIS_getCurrentFds(hObject);

if ~isstruct(fds)
    errordlg('No data loaded to be assigned.')
    return
end



[file, pathname] = uigetfile('*.csv');

if file==0
    return
end

InputFile = fullfile(pathname,file);

Tmp = fopen(InputFile);
ExportNames  = strsplit(fgetl(Tmp), ',');
fclose(Tmp);




T = readtable(InputFile);

T.Properties;

Tr = table2array(T);

if iscell(Tr)
    errordlg('Faulty FTI file - contains non-numerical data. Abort')
    fds = -1;
    return
end


% add data to fds
fdata = Tr;

varNames = ExportNames';

varUnits = cell(size(varNames));
varUnits = cellfun(@(x) '', varUnits, 'UniformOutput', false);

varFrames = cell(size(varUnits));
varFrames = cellfun(@(x) '', varFrames, 'UniformOutput', false);

fds = kVIS_fdsAddDataGroup(fds, 'Imported', 'AirData', varNames, varUnits, varFrames, fdata);



kVIS_updateDataSet(hObject, fds, name)

end