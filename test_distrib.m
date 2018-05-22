close all
clear
clc

MIN = 0.5;
MAX = 4;
MEAN = 1;

N = 1e6;

rand_uni =  MIN + (MAX-MIN)*rand(N/2,1);
% hist(rand_uni,1000)

rand_norm = MEAN + 0.2.*randn(N,1);
% hist(rand_norm,1000)

rand_task = [rand_uni ; rand_norm];

rand_task( rand_task<MIN ) = [];
rand_task( rand_task>MAX ) = [];
rand_task = Shuffle(rand_task); rand_task = Shuffle(rand_task);

subplot(2,1,1)
hist(rand_task,1000)

n = 128;
RAND = rand_task(1:n);
RAND = round(RAND*60)/60;
subplot(2,1,2)
hist(RAND,n*2)

mean(rand_task)


%%

% x = 0:0.001:4;

% a = 2;
% b = 5;

% f = a*b*x.^(a-1).*(1-x.^a).^(b-1) ;

% plot(x,f);

% med = (1-2.^(-1/b)).^(1/a)
% mean = a/(a+b);


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

% y = exppdf(x,2);
% 
% plot(x,y)

