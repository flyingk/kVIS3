function output_txt = kVIS_dataCursor_Callback(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% get data
pos = get(event_obj,'Position');

% format output
answ = inputdlg({'Digits X', 'Digits Y', 'Number format [dec, hex or bin]'}, 'Data tip format', 1, {'6', '6', 'dec'});

if strcmp(answ{3}, 'dec')
    
    output_txt = {...
        ['X: ',num2str(pos(1), str2double(answ{1}) )],...
        ['Y: ',num2str(pos(2), str2double(answ{2}) )]};
    
elseif strcmp(answ{3}, 'hex')
    
    a = pos(2);
    hexstr = dec2hex(round(a));
    
    output_txt = {...
        ['X: ',num2str(pos(1), str2double(answ{1}) )],...
        ['Y: ',['0x' hexstr]]};
    
elseif strcmp(answ{3}, 'bin')
    
    a = pos(2);
    binstr = dec2bin(round(a));
    
    output_txt = {...
        ['X: ',num2str(pos(1), str2double(answ{1}) )],...
        ['Y: ',['0b' binstr]]};
    
else
    errordlg('Wrong number format for datatip.')
end

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),8)];
end

end
