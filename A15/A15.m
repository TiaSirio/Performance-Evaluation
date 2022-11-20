clc, clear;

arrivalRate = [10, 0, 0];
serviceTimes = [0.040, 0.1, 0.12];
%arrivalRate = [0.5, 0, 0];
%serviceTimes = [1, 2, 2.5];

globalSpeed = sum(arrivalRate);
throughput = globalSpeed;

l = [0, 0, 0];

pGen = [0, 0.3, 0.2;
        1,   0,   0;
        0.2, 0.8,  0];

%{
pGen = [0.7, 0.3, 0;
        0.5, 0, 0.3;
        1,   0,  0];
%}

I = eye(3);

for k = 1:length(arrivalRate)
    l(1, k) = arrivalRate(1, k)/globalSpeed;
end

visitsOfStations = l * (I - pGen)^-1;

serviceDemandsOfStations = [0, 0, 0];

throughputOfStations = visitsOfStations * throughput;

for i = 1:length(visitsOfStations)
    serviceDemandsOfStations(1, i) = visitsOfStations(1, i) * serviceTimes(1, i);
end

for j = 1:length(visitsOfStations)
    fprintf("%f\n", visitsOfStations(1, j));
    fprintf("%f\n", serviceDemandsOfStations(1, j));
    fprintf("%f\n", throughputOfStations(1, j));
    fprintf("\n");
end