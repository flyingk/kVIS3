function [y, x, c] = kVIS_limit_fcn(data, varargin)

x = [];
c = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');

%% function specific code
upperLimit = str2double(args{1});
lowerLimit = str2double(args{2});

data(data>upperLimit) = NaN;
data(data<lowerLimit) = NaN;

y = data;
end