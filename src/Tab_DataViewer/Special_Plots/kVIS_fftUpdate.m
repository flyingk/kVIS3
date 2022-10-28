% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function kVIS_fftUpdate(~, ~)

% active time panel
sourcePanel = kVIS_dataViewerGetActivePanel();
% link target
targetPanel = sourcePanel.linkTo;

if isempty(targetPanel)
    errordlg('Cannot find data source. Ensure the corresponding timeplot is selected for manual update...')
    return
end

% plot axes
ax = targetPanel.axesHandle;

% has frequency range been set? New panel?
if isempty(targetPanel.fftRange)
    targetPanel.fftRange = [0.01 10];
    ax.XLim = [-inf inf];
    ax.YLim = [-inf inf];
end

if isempty(targetPanel.fftType)
    targetPanel.fftType = 'PSD';
end

lines = findobj(sourcePanel, 'Type', 'Line');

% generate psd
if ~isempty(lines)
    
    targetPanel.fftYLim = ax.YLim;
    
    % clear plot
    cla(ax);
    
    % get selected range
    xRange = kVIS_getDataRange(gcf, 'XLim');
        
    % save axes style (lin/log)
    xScale = ax.XScale;
    yScale = ax.YScale;
    
    ll = size(lines,1);
    
    if ll > 1
        hold(ax, 'on');
    else
        hold(ax, 'off');
    end
    
    fmin = targetPanel.fftRange(1);
    fmax = targetPanel.fftRange(2);
    
    for i=1:ll
        % generate psd - needs to be done one by one to account for
        % potentially different sample rates...
        signal = lines(i).YData';
        timeVec= lines(i).XData';
        colour = lines(i).Color;
        
        % generate psd for selected range
        locs = find(timeVec >= xRange(1) & timeVec <= xRange(2));
        signal = signal(locs);
        timeVec= timeVec(locs);
        
        if any(isnan(signal))
            errordlg('Signal contains NaN. FFT not possible at the moment...')
            return
        end
        
        w = [fmin:0.01:fmax]*2*pi;
        
        if strcmp(targetPanel.fftType, 'PSD')
                        
            [p, f] = spect(signal-mean(signal), timeVec, w, 10, 0, 0);
            
            plot(ax, f, p, 'Color', colour)
            
        elseif strcmp(targetPanel.fftType, 'FFT')
            
            [Y, f] = DFT(signal-mean(signal), timeVec, w, 10);
            
            plot(ax, f, abs(Y), 'Color', colour)
            
        end

    end
    
    grid(ax, 'on');
    
    ax.UIContextMenu = kVIS_createFFTContextMenu(ax);
    ax.XScale = xScale;
    ax.YScale = yScale;
    
    ax.YLim = targetPanel.fftYLim;
    ax.XLim = [fmin, fmax];
    
    xlabel(ax, 'Frequency [Hz]');

    if strcmp(targetPanel.fftType, 'PSD')
        ylabel(ax, 'Power Spectral Density (PSD)');
        oldM = findobj(ax.UIContextMenu, 'Text', 'PSD plot');
        oldM.Checked = 'on';
    elseif strcmp(targetPanel.fftType, 'FFT')
        ylabel(ax, 'FFT Magnitude');   
        oldM = findobj(ax.UIContextMenu, 'Text', 'FFT plot');
        oldM.Checked = 'on';
    end
    
    handles = guidata(gcf);
    kVIS_setGraphicsStyle(ax, handles.uiTabDataViewer.plotStyles.Axes);
    kVIS_axesResizeToContainer(ax);
end


end

function [ m ] = kVIS_createFFTContextMenu(ax)
% This function creates a context menu for a given Line object.
% The menu displays some metadata helping to identify the line, and
% provides some callback actions.

m = uicontextmenu();

% metadata section
%     uimenu('Parent', m, 'Label', sprintf('Type: %s', panel.UserData.PlotType), 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Units: %s' , strip(line.UserData.signalMeta.unit))       , 'Enable', 'off');
%     uimenu('Parent', m, 'Label', sprintf('Data Set: %s', strip(line.UserData.signalMeta.dataSet)), 'Enable', 'off');
%     if isstruct(line.UserData) && isfield(line.UserData, 'yyaxis')
%         uimenu('Parent', m, 'Label', sprintf('Y Axis: %s', line.UserData.yyaxis), 'Enable', 'off');
%     end

uimenu( ...
    'Parent', m, ...
    'Label', 'FFT plot', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'PSD plot', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Force Update', ...
    'Separator','on',...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'linear', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'log x', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'log y', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'loglog', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Set Frequency Range', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );
uimenu( ...
    'Parent', m, ...
    'Label', 'Reset Limits', ...
    'Callback', {@kVIS_fftContextMenuAction, ax} ...
    );

end


function [Y, ff] = DFT(y,t,w,navg)
%
%  SPECT  Computes power spectral density estimates for measured time series.  
%
%  Usage: [P,f,Y,wdw] = spect(y,t,w,navg,ldw,lplot);
%
%  Description:
%
%    Estimates the one-sided auto spectral density 
%    using data windowing in the time domain to reduce 
%    leakage, and averaging in the frequency domain to 
%    reduce random error.  The power spectral density 
%    is computed using frequency vector f=w/(2*pi).  The 
%    Fourier transform Y is computed on a fine frequency 
%    grid with navg values inserted between each frequency 
%    point specified in the w vector.  Input navg is 
%    the number of averages used to generate each value 
%    of P at the frequency points specified in the 
%    w vector.  The variance of the power spectral  
%    density estimates = (1/navg)*100 percent
%    of the spectral density estimates.  Inputs w,  
%    navg, and lplot are optional.  The defaults 
%    give the same number of auto spectral density 
%    estimates as time domain points, with variance equal to 
%    10 percent of the estimated auto spectral densities, 
%    with the plot included.  
%
%  Input:
%    
%        y = matrix of time series column vectors.
%        t = time vector.
%        w = frequency vector, rad/sec.
%     navg = number of averages in the frequency domain.  
%      ldw = data windowing flag:
%            = 1 for data windowing (default).
%            = 0 to omit the data windowing. 
%    lplot = plot flag:
%            = 1 for auto spectral density plot (default).
%            = 0 to skip the plot. 
%
%  Output:
%
%    P    = auto spectral density.
%    f    = vector of frequencies corresponding to the elements of P, Hz.
%    Y    = discrete Fourier transform of y on a fine frequency grid.  
%    wdw  = time-domain windowing function.
%

%
%    Calls:
%      cvec.m
%      czts.m
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      28 Oct 2004 - Created and debugged, EAM.
%      11 Nov 2004 - Modified inputs, EAM.
%      03 Oct 2005 - Corrected frequency vector endpoint treatment, EAM.
%
%  Copyright (C) 2006  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@nasa.gov
%

[npts,n]=size(y);
%
%  Time vector information used for frequency scaling.
%
t=cvec(t);
npts=length(t);
dt=(t(end)-t(1))/length(t);
fs=1/dt;
%
%  Default inputs.
%
if nargin < 4
  navg=10;
end
if any(size(navg)~=1)
	error('Input navg must be a scalar.')
end
%
%  Assemble the frequency vector.
%
if nargin < 3
  df=1/(npts*dt);
  f=[0:df:fs/2]';
  w=2*pi*f;
else
  w=cvec(w);
  f=w/(2*pi);
  df=f(2)-f(1);
end
nf=length(f);
f1=max(min(f),0);
f2=min(max(f),fs/2);
%
%  Assemble the fine grid frequency vector.
%
%  Make the number of averages odd, 
%  so that the original frequency grid 
%  can be maintained easily. 
%
if mod(navg,2)==0
  navg=navg+1;
end
dff=df/navg;
ff=[f1:dff:f2]';
%
%  If lower limit of the frequency range 
%  is not zero, extend the fine grid 
%  frequency vector, to get full accuracy 
%  at the endpoint frequency f1.  
%
if f1 > 0
  ff=[f1-fix(navg/2)*dff:dff:f2]';
end
%
%  Similarly for the upper limit of the 
%  frequency range f2.  
%
if f2 < fs/2
  ff=[min(ff):dff:f2+fix(navg/2)*dff]';
end
M=length(ff);

wdw=ones(npts,1);
%
%  Complex step for the chirp z-transform.
%
jay=sqrt(-1);
W=exp(-jay*2*pi*dff*dt);
%
%  Stay on the unit circle in the z-plane,
%  and start at the initial frequency min(ff).  
%
A=1*exp(jay*2*pi*min(ff)*dt);
%
%  Compute the chirp z-transform 
%  for the fine frequency grid.
%
Y=czts(y.*wdw(:,ones(1,n)),M,W,A);

end