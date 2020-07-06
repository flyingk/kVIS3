function kVIS_generateReport(file)

% open report definition file
fidIN = fopen(file,'r');

% select destination folder
outFolder = uigetdir();

% create plot directory
mkdir(fullfile(outFolder,'img'))

fidOUT = fopen(fullfile(outFolder,'kVIS_report_trial_2.tex'),'w');


while ~feof(fidIN)
    
    l = strip(fgetl(fidIN));
    
    if contains(l, '%_kVIS_aircraft_properties')
        kVIS_writeAcDataTable(fidOUT);
        
    elseif contains(l, '%_kVIS_test_info')
        kVIS_writeTestInfoTable(fidOUT);
        
    elseif contains(l, '%_kVIS_plot')
        disp('plots')
        
        % generate plots
        pltName = strsplit(l,{'{','}'});
        fileNames = plotting(pltName{2},outFolder);
        
        % generate tex with plot names
        for I = 1:length(fileNames)
            kVIS_writePlotElement(fidOUT, fileNames{I});
        end
        
    else
        fprintf(fidOUT,'%s\n',l);
    end
    
end

fclose(fidIN);
fclose(fidOUT);

end

function fileNames = plotting(plotName, outFolder)
% 
% % get GUI data
% handles = guidata(hObject);
% 
% try
%     [fds, fds_name] = kVIS_getCurrentFds(hObject);
% catch
%     disp('No fds loaded. Abort.')
%     return;
% end

fds = evalin('base','ARQ_105');

%
% Read plot definition
%

if endsWith(plotName,".xlsx")
    [~,~,PlotDefinition] = xlsread(plotName,'','','basic');
end


% % % plot full data length
% if handles.uiTabPlots.plotsUseLimitsBtn.Value == 0
%     
%     xlim = kVIS_fdsGetGlobalDataRange(hObject);
%     
% else % use X-Limits (if button pressed or for events)
%     
%     xlim = kVIS_getDataRange(hObject, 'XLim');
%     
% end
xlim = [fds.fdataAttributes.startTimes(2) fds.fdataAttributes.stopTimes(2)];

tic

fileNames = kVIS_generateReportPlotXLS(fds, PlotDefinition, xlim, [], outFolder);

toc

end