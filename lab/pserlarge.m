function pserlarge(xV, nseg, tittxt, type, tau_s, ignore)
% pserlarge(xV, nseg, tittxt, type, tau_s, ignore)
% PSERLARGE gives the time history diagram of a time series
% in one figure, optionally organized on successive segments 
% plotted on top of eachother.
% INPUTS:
%  xV      : vector of a scalar time series
%  nseg    : number of successive segments plotted on each other. 
%  tittxt  : string to be displayed in the title
%  type    : if 'd' (for discrete) then data points are displayed 
%            with dots, if 'c' lines are used, and otherwise lines and 
%            dots are used. 
%  tau_s   : sampling time in order to specify the real time on x-axis.
%            For dicrete-type data tau_s should be assigned to one. 
%  ignore  : if specified and it is 1 (meaning yes) then the last samples 
%            (equal to length(xV) mod nseg) are ignored. 

if nargin == 5
    ignore = 1;
elseif nargin == 4
    ignore = 1;
    tau_s = 1;
elseif nargin == 3
    ignore = 1;
    tau_s = 1;
    type = 'b';
elseif nargin == 2
    ignore = 1;
    tau_s = 1;
    type = 'b';
    tittxt = [];
elseif nargin == 1
    ignore = 1;
    tau_s = 1;
    type = 'b';
    tittxt = [];
    nseg = 1;
end
if isempty(ignore)
    ignore = 1;
end
if isempty(tau_s)
    tau_s = 1;
end
if isempty(type)
    type = 'b';
end
if isempty(nseg)
    nseg = 1;
end

n = length(xV);
n1 = floor(n / nseg);
if ~ignore && n / nseg ~= n1  
    nsub = nseg+1;
else
    nsub = nseg;
end
xmin = min(xV);
xmax = max(xV);
dmax = xmax - xmin;

h = figure(gcf);
clf
hold on
for i=1:nseg
    if type == 'd'
        plot([1:n1]'*tau_s, (i-1)*dmax+xV((i-1)*n1+1:i*n1)-xmin, 'k.')
    elseif type == 'c'
        plot([1:n1]'*tau_s, (i-1)*dmax+xV((i-1)*n1+1:i*n1)-xmin, 'k')
    else
        plot([1:n1]'*tau_s, (i-1)*dmax+xV((i-1)*n1+1:i*n1)-xmin, '.-k')
    end 
    text(0,i*dmax-dmax/2,[num2str(((i-1)*n1+1)*tau_s),'-',num2str(i*n1*tau_s)],...
        'HorizontalAlignment', 'right')
end
if nsub > nseg
    if type == 'd'
        plot([1:n-nseg*n1]'*tau_s, nseg*dmax+xV(nseg*n1+1:n)-xmin, 'k.')
    elseif type == 'c'
        plot([1:n-nseg*n1]'*tau_s, nseg*dmax+xV(nseg*n1+1:n)-xmin, 'k')
    else
        plot([1:n-nseg*n1]'*tau_s, nseg*dmax+xV(nseg*n1+1:n)-xmin, '.-k')
    end  
    text(0,(nseg+1)*dmax-dmax/2,[num2str((nseg*n1+1)*tau_s),'-',num2str(n*tau_s)],...
        'HorizontalAlignment', 'right')
end
axis([tau_s n1*tau_s 0 dmax*nsub])
set(get(h, 'CurrentAxes'), 'YTickLabel', [])
title([tittxt, ': time history, ', int2str(n), ' data'])
xlabel(['t (sampling time =', num2str(tau_s,2), ')'])
