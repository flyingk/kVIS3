function [y, x, c] = kVIS_errorColor_fcn(data, varargin)
% subtracts two signals and provides line colors corresponding to an error
% band

x = [];
c = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');

%% function specific code
operatorChPath = args{1};
limit          = str2double(args{2});

ccF = strsplit(operatorChPath, '/');
operatorCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});

if operatorCh == -1
    disp('Function channel not found... Ignoring.')
    y = data;
    return
end

operatorCh = operatorCh(pts);


y = data - operatorCh;

c = zeros(length(y),1);

c(abs(y)>limit) = 1;
end