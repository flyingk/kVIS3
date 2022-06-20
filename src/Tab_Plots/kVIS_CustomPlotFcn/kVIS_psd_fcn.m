function [y, x, c] = kVIS_psd_fcn(data, varargin)

x = [];
c = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{3}, ',');


%% function specific code
timeChPath = args{1};
fmin       = str2double(args{2});
fmax       = str2double(args{3});

ccF = strsplit(timeChPath, '/');
timeCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});

if timeCh == -1
    disp('Function channel not found... Ignoring.')
    y = data;
    return
end

w = (fmin:0.01:fmax)*2*pi;

% generate psd, remove bias from signal
[y, x] = spect(data-mean(data), timeCh(pts), w, 10, 0, 0);
end