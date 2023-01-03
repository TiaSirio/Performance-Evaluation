%% INTRO
clc, clear

SPEC = 1;
DESIGN = 2;
BREADBOARD = 3;
SW = 4;
TEST = 5;

names = ["Spec", "Design", "Breadbrd", "Software", "Test"];

names = string(names);

fileOrigin = "Traces/TraceC-";
fileFinalPart = ".txt";

duration = table;

for col = 1:size(names, 2)
    file = strcat(fileOrigin, names(col), fileFinalPart);
    duration(:,col) = array2table(csvread(file));
end

duration.Properties.VariableNames = names;

N = size(duration, 1);

HyperExpCDF = @(p, t) 1 - p(1,3) * exp(-p(1,1) * t) - (1 - p(1,3)) * exp(-p(1,2) * t);
HyperExpMoments = @(p, t) [t/p(1,1) + (1-t)/p(1,2), 2 * (t/(p(1,1)^2) + (1-t)/(p(1,2)^2)), 6 * (t/(p(1,1)^3) + ((1-t)/(p(1,2)^3)))];


%% SPEC

t = duration.Spec;
t = sortrows(t);
sigma = std(t);
mu = sum(t) / N;
cv = sigma / mu;
max_value = t(N);
interval = (0:0.1:max_value);
k = 1/(cv)^2;
theta = mu/k;
yGammaCDFSpec = gamcdf(interval, k, theta);

figure;
plot(t, (1:N)/N, ".b", interval, yGammaCDFSpec', "r");
legend("Trace", names(SPEC));
title(names(SPEC));

%% DESIGN

t = duration.Design;
t = sortrows(t);
sigma = std(t);
mu = sum(t) / N;
cv = sigma / mu;
max_value = t(N);
interval = (0:0.1:max_value);
k = 1/(cv)^2;
theta = mu/k;
yGammaCDFSpec = gamcdf(interval, k, theta);

figure;
plot(t, (1:N)/N, ".b", interval, yGammaCDFSpec', "r");
legend("Trace", names(DESIGN));
title(names(DESIGN));

%% BREADBOARD

t = duration.Breadbrd;
t = sortrows(t);

sigma = std(t);
mu = sum(t) / N;
m2 = sum(t.^2) / N;
m3 = sum(t.^3) / N;

cv = sigma / mu;

max_value = t(N);
interval = (0:0.1:max_value);

FunctionHyperEM = @(p) (HyperExpMoments(p(1, 1:2), p(1,3)) ./ [mu, m2, m3] - 1);

if cv > 1
    lambda = [(0.8 / mu), (1.2 / mu)];
    p = 0.4;
    var = [lambda(1,1), lambda(1,2), p];

    res = fsolve(FunctionHyperEM, var);
    p = res(3);
    lambda = res(1:2);
    y2HyperExpM = HyperExpCDF(res, interval);

    figure
    plot(t, (1:N)/N, ".b", interval, y2HyperExpM, "r");
    legend("Traces", names(BREADBOARD));
    title(names(BREADBOARD));
end

%% SW

t = duration.Software;
t = sortrows(t);

sigma = std(t);
mu = sum(t) / N;
m2 = sum(t.^2) / N;
m3 = sum(t.^3) / N;

cv = sigma / mu;

max_value = t(N);
interval = (0:0.1:max_value);

FunctionHyperEM = @(p) (HyperExpMoments(p(1, 1:2), p(1,3)) ./ [mu, m2, m3] - 1);

if cv > 1
    lambda = [(0.8 / mu), (1.2 / mu)];
    p = 0.4;
    var = [lambda(1,1), lambda(1,2), p];

    res = fsolve(FunctionHyperEM, var);
    p = res(3);
    lambda = res(1:2);
    y2HyperExpM = HyperExpCDF(res, interval);

    figure
    plot(t, (1:N)/N, ".b", interval, y2HyperExpM, "r");
    legend("Traces", names(SW));
    title(names(SW));
end


%% TEST

t = duration.Test;
t = sortrows(t);

mu = sum(t) / N;
lambda = 1  / mu;

max_value = t(N);
interval = (0:0.1:max_value);
yExp = 1 - exp(-lambda * interval);

figure;
plot(t, (1:N)/N, ".b", interval, yExp', "r");
legend('Trace', names(TEST));
title(names(TEST));



%% Closed model - MVA

d = [duration.Spec, max(duration.Design + duration.Breadbrd, duration.Software), duration.Test];

d = mean(d);

N = 2;

Nk = zeros(1,3);
Rk = zeros(1,3);
R = 0;
X = 0;

for i = 1:N
    Rk = d .* (Nk + 1);
    R = sum(Rk);
    X = i / (R);
    Nk = X .* Rk;
end

Uk = d * X;

PSI = X/R;