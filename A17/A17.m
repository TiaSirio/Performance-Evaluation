clc, clear;

%N = 530;
%serviceTimes = [0.080, 0.120, 0.11];
%visitsOfStations = [1, 0.75, 10];
%thinkTime = 120;
N = 100;
serviceTimes = [0.050, 0.150, 0.025];
visitsOfStations = [0.7, 0.2, 1];
thinkTime = 10;

serviceDemandsOfStations = [0, 0, 0];

for i = 1:length(visitsOfStations)
    serviceDemandsOfStations(1, i) = visitsOfStations(1, i) * serviceTimes(1, i);
end

Nk = [0, 0, 0];
Rk = [0, 0, 0];
R = 0;
X = 0;

for i = 1:N
    Rk = serviceDemandsOfStations .* (Nk + 1);
    R = sum(Rk);
    X = i / (R + thinkTime);
end

Uk = serviceDemandsOfStations * X;

%Number of job thinking
Nz = N - sum(Nk);

%Uk = Xk .* serviceTimes;