function [y, x] = kVIS_demo_fcn(data, varargin)

x = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');


% function specific code
y = data;

end