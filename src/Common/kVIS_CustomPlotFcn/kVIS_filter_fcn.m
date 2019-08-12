function [y,x] = filter_fcn(data, varargin)

x = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');


%% function specific code
timeChPath = args{1};
fc         = str2double(args{2});
type       = str2double(args{3});

ccF = strsplit(timeChPath, '/');
timeCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});

if timeCh == -1
    disp('Function channel not found... Ignoring.')
    y = data;
    return
end

dt = mean(diff(timeCh));

y = fdfilt(data, fc, dt, type);
end