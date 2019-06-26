clear
clc

mkdir compile

% collect all app files
% files = getAllFiles('../','.m');
% 
% for i=1:length(files)
%     copyfile(files{i},'./compile')
% end

files = getAllFiles('../src','.m');

for i=1:length(files)
    copyfile(files{i},'./compile')
end

% collect all bsp files
files = getAllFiles('/Users/kai.lehmkuehler/developer/051_kVIS_Board_Support_Package/Lilium_Phoenix','.m');

for i=1:length(files)
    copyfile(files{i},'./compile')
end

