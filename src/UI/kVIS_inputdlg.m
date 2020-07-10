
function [Answer] = kVIS_inputdlg(Prompt, Title, NumLines, DefAns)

f=figure('Position',[0 0 900 900],...
    'MenuBar','none',...
    'Toolbar','none',...
    'NumberTitle','off',...
    'Visible','off',...
    'WindowStyle','modal',...
    'KeyPressFcn',@keyP);


main_div = uix.VBox('Parent', f, 'Tag', 'vbox');

inputs = uix.Grid('Parent', main_div);
inputs.Tag = 'inputs';

ctrls= uix.HButtonBox('Parent', main_div, ...
    'Backgroundcolor', getpref('kVIS_prefs','uiBackgroundColour'), ...
    'Spacing', 50, ...
    'HorizontalAlignment', 'right',...
    'Tag','btnBox');

main_div.Heights = [-1 40];


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
    uicontrol('Parent', inputs, 'Style','text', 'String', Prompt{I}, 'FontSize', 14)
    answ(I) = uicontrol('Parent', inputs, 'Style', 'edit', 'String', DefAns{I}, 'KeyPressFcn',@keyP);
end

if I < 10
    set( inputs, 'Widths', [200], 'Heights', ones(1, I*2)*-1 );
else
    % odd/even number of fields?
    oe = mod(I,2);
    spc = ones(1, I - oe) * -1;
    spc(1:2:length(spc)) = 20;
    if oe == 0
        
        set( inputs, 'Widths', [200 200], 'Heights', spc );
        f.Position(3) = 430;
    else
        
        set( inputs, 'Widths', [200 200 200], 'Heights',  spc);
        f.Position(3) = 640;
    end
end

set(inputs, 'Spacing', 10)
set(inputs, 'Padding', 10)


movegui(f,'center')

f.Visible = 'on';

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