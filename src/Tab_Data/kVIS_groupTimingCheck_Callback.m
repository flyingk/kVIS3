function kVIS_groupTimingCheck_Callback(hObject, ~)
% Display timing information

handles = guidata(hObject);

[fds, ~] = kVIS_getCurrentFds(hObject);

groupNo = handles.uiTabData.groupTree.SelectedNodes.Value;

groupName = fds.fdata{fds.fdataRows.groupLabel, groupNo};

[t, ~] = kVIS_fdsGetChannel(fds, groupName, 'Time');

%time step
dt = (t(end)-t(1))/length(t);
t=t-t(1);
t1=t;

x = 1:length(t);
base = 0:0.01:length(t)/100;
base = base(1:end-1);

difft=diff(t);

bad=find(difft>0.011);
badno = size(bad,1);

f1 = figure();
ax_l = subplot(1,2,1);
ax_r = subplot(1,2,2);

plot(ax_l,x/100,t'-base)
xlabel(ax_l,'sec','Color','k')
ylabel(ax_l,'\int\Delta t','Color','k')
title(ax_l,'Overall timing accuracy','Color','k')
grid(ax_l,'on')
% set(ax_l,'XColor','w');
% set(ax_l,'YColor','w');
% set(ax_l,'GridColor','k');
% set(ax_l,'MinorGridColor','k');

plot(ax_r,x(1:end-1),difft)
xlabel(ax_r,'step','Color','k')
ylabel(ax_r,'\Delta t','Color','k')
title(ax_r,'Time step durations','Color','k')
grid(ax_r,'on')
% set(ax_r,'XColor','w');
% set(ax_r,'YColor','w');
% set(ax_r,'GridColor','k');
% set(ax_r,'MinorGridColor','k');