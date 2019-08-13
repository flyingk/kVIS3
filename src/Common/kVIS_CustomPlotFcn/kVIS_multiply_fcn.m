function [y, x] = kVIS_multiply_fcn(data, varargin)

x = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');


%% function specific code
operatorChPath = args{1};

ccF = strsplit(operatorChPath, '/');
operatorCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});


y = data .* operatorCh(pts); 
end