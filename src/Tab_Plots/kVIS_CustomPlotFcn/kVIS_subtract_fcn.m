function [y, x, c] = kVIS_subtract_fcn(data, varargin)

x = [];
c = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
if ~isnumeric(varargin{3})
    
    operatorChPath = varargin{3};
    
    ccF = strsplit(operatorChPath, '/');
    operatorCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});
    
    if operatorCh == -1
        disp('Function channel not found... Ignoring.')
        y = data;
        return
    end
    
    operatorCh = operatorCh(pts);
else
    
    % add a constant to data
    operatorCh = ones(length(data),1) * varargin{3};
    
end

y = data - operatorCh;
end