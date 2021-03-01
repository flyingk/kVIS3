
function [Answer] = kVIS_inputdlg(Prompt, Title, ~, DefAns)

f=figure('Position',[0 0 900 900],...
    'MenuBar','none',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'Visible','off',...
    'WindowStyle','modal',...
    'Name', Title,...
    'KeyPressFcn',@keyP);


main_div = uix.VBox('Parent', f, 'Tag', 'vbox');

inputs = uix.Grid('Parent', main_div, 'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'));
inputs.Tag = 'inputs';

ctrls= uix.HButtonBox('Parent', main_div, ...
    'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'), ...
    'Spacing', 50, ...
    'HorizontalAlignment', 'right',...
    'Tag','btnBox');

buttonStripHeight = 40;

main_div.Heights = [-1 buttonStripHeight];


uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'Cancel', ...
    'Callback', @btnP2 ...
    );

uicontrol( ...
    ctrls, ...
    'Style', 'pushbutton', ...
    'String', 'OK', ...
    'Callback', @btnP ...
    );

ctrls.ButtonSize = [100 30];

%% input fields

for I = 1:length(DefAns)
    uicontrol('Parent', inputs, 'Style','text', 'String', Prompt{I},...
        'Foregroundcolor','w', 'FontSize', 14, 'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'))
    answ(I) = uicontrol('Parent', inputs, 'Style', 'edit', 'String', DefAns{I}, 'KeyPressFcn',@keyP);
end

if I < 10
    set( inputs, 'Widths', [200], 'Heights', ones(1, I*2)* 30 );
else
    % odd/even number of fields?
    oe = mod(I,2);
    spc = ones(1, I - oe) * 30;
    spc(1:2:length(spc)) = 20;
    if oe == 0
        
        set( inputs, 'Widths', [200 200], 'Heights', spc );
        f.Position(3) = 430;
        f.Position(4) = sum(spc) + (length(spc)+1) * 10 + buttonStripHeight;
    else
        
        set( inputs, 'Widths', [200 200 200], 'Heights',  spc);
        f.Position(3) = 640;
        f.Position(4) = sum(spc) + (length(spc)+1) * 10 + buttonStripHeight;
    end
end

set(inputs, 'Spacing', 10)
set(inputs, 'Padding', 10)

% move to center
movegui(f,'center')

% show window
f.Visible = 'on';

% set focus to first element
uicontrol(answ(1))


%% wait for user input
uiwait(f);



%% resume
if strcmp(f.UserData, 'OK')
    
    for I = 1:length(DefAns)
        Answer{I} = answ(I).String;
    end
    
    Answer;
    
else
    
    Answer = [];    
end

delete(f)
end

% OK button
function btnP(src, event)

event;

set(gcbf,'UserData','OK');

uiresume(gcbf);

end

% Cancel button
function btnP2(src, event)

set(gcbf,'UserData','Cancel');

uiresume(gcbf);

end

% process keyboard entries
function keyP(src, event)

switch(event.Key)
    
    % enter key
  case {'return'}
    pause(0.2) % for edit entry to register...
    
    btnP(src, event)
    
    % esc key
  case {'escape'}
      
    btnP2(src, event)
end

end