close all
clear
clc

MIN = 0.5;
MAX = 4;
MEAN = 1;

x = 0:0.001:4;

a = 2;
b = 5;

f = a*b*x.^(a-1).*(1-x.^a).^(b-1) ;

% plot(x,f);

% med = (1-2.^(-1/b)).^(1/a)
mean = a/(a+b);


%%

% x = [5+randn(1e6,1)];
% [f,xi] = ksdensity(x);
% plot(xi,f);

% n = 100;
% xmean = MEAN;
% xmin = MIN;
% xmax = MAX;
% xeps = 0.01;
% x = xmin + (xmax-xmin)*rand(n,1);
% [f,xi] = ksdensity(x);
% plot(xi,f);
% c=0;
% while abs(xmean - mean(x)) >= xeps
%     if xmean > mean(x)
%         samples_idx = find(x < xmean);
%         x(samples_idx) = xmax + (xmean-xmax)*rand(length(samples_idx),1);
%     elseif xmean < mean(x)
%         samples_idx = find(x > xmean);
%         x(samples_idx) = xmean + (xmin-xmean)*rand(length(samples_idx),1);
%     end
%     c=c+1
% end

%%

y = exppdf(x,2);

plot(x,y)

