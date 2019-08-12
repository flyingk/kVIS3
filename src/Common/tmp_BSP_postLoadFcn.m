function [ fds ] = BSP_postLoadFcn(fds)

%
% generate channel label items from provided name
%

for i = 1 : fds.fdataAttributes.nFiles
    
    if isempty(fds.fdata{fds.fdataRows.varNames,i})
        continue;
    end
    
    names = fds.fdata{fds.fdataRows.varNames,i};
    
    len = length(names);
    
    dispNames = cell(len,1);
    units = cell(len,1);
    frames = cell(len,1);
    texNames = cell(len,1);
    
    for j = 1:len
        
        SignalInfo = ExtractInfoFromSignalName(names{j});
%         SignalInfo.Data
        
        if ~isempty(SignalInfo.Data.Axis)
            sa = [SignalInfo.Data.Symbol SignalInfo.Data.Axis];
        else
            sa = SignalInfo.Data.Symbol;
        end
        s = [sa SignalInfo.Data.Subscripts];
        dispNames(j) = join(s,'_');
        
        units{j}    = SignalInfo.Data.Unit;
        frames{j}   = SignalInfo.Data.Frame;
        
        texNames{j}  = SignalInfo.TeX_Name;
    end
    
    fds.fdata{fds.fdataRows.varNamesDisp,i} = dispNames;
    fds.fdata{fds.fdataRows.varUnits,i}     = units;
    fds.fdata{fds.fdataRows.varFrames,i}    = frames;
    
    fds.fdata{fds.fdataRows.varLabelsTeX,i} = texNames;
    
end

end

% ans = 
% 
%   struct with fields:
% 
%        RawName: 'V_y_K_cmd_UNIT_m_d_s_FRAME_FP'
%         Symbol: 'V'
%           Axis: 'y'
%           Unit: 'm/s'
%          Frame: 'FP'
%     Subscripts: {'K'  'cmd'}