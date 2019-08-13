function y = kVIS_demo_fcn(data, varargin)

% first argument is the data structure
fds  = varargin{1};

% separate argument string supplied from spreadsheet
args = strsplit(varargin{2}, ',');


% function specific code
timeChPath = args{1};
fc         = str2double(args{2});

ccF = strsplit(timeChPath, '/');
timeCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});

dt = mean(diff(timeCh));



y = fdfilt(data, fc, dt);

end


%         % check if operator is numeric constant or channel name
%         if ~isnumeric(plotDef{i, fcnChannel})
%             
%             
%             if fcnData == -1
%                 disp('Function channel not found... Ignoring.')
%                 k=k-1;
%                 continue;
%             end
%         else
%             fcnData = ones(length(yp),1) * plotDef{i, fcnChannel};
%         end