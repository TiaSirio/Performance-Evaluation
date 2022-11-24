clc, clear;

arrivalRate = [10, 0, 5];
serviceTimes = [0.085, 0.075, 0.060];
%arrivalRate = [10, 0, 0];
%serviceTimes = [0.085, 0.075, 0.060];

totalArrivalRate = sum(arrivalRate);
throughput = totalArrivalRate;

l = [0, 0, 0];

pGen = [0, 1, 0;
        0, 0, 1;
        0, 0, 0];

I = eye(3);

for k = 1:length(arrivalRate)
    l(1, k) = arrivalRate(1, k)/totalArrivalRate;
end

visitsOfStations = l * (I - pGen)^-1;

serviceDemandsOfStations = [0, 0, 0];

throughputOfStations = visitsOfStations * throughput;

for i = 1:length(serviceDemandsOfStations)
    serviceDemandsOfStations(1, i) = visitsOfStations(1, i) * serviceTimes(1, i);
end

%serviceDemandsOfStations = [0.085, 0.075, 0.050];

utilizationOfStation = throughput * serviceDemandsOfStations;

residenceTimeOfStation = [0, 0, 0];

for i = 1:length(residenceTimeOfStation)
    residenceTimeOfStation(1, i) = serviceDemandsOfStations(1, i)/(1 - utilizationOfStation(1, i));
end

averageNumberOfJobInStation = totalArrivalRate * residenceTimeOfStation;

averageSystemResponseTime = sum(residenceTimeOfStation);

fprintf("Visits\n");
for j = 1:length(visitsOfStations)
    fprintf("%f\n", visitsOfStations(1, j));
end
fprintf("\n");

fprintf("Demands\n");
for j = 1:length(serviceDemandsOfStations)
    fprintf("%f\n", serviceDemandsOfStations(1, j));
end
fprintf("\n");

fprintf("Throughput\n");
fprintf("%f\n", throughput);
fprintf("\n");

fprintf("Utilization\n");
for j = 1:length(utilizationOfStation)
    fprintf("%f\n", utilizationOfStation(1, j));
end
fprintf("\n");

fprintf("Average number of jobs\n");
for j = 1:length(averageNumberOfJobInStation)
    fprintf("%f\n", averageNumberOfJobInStation(1, j));
end
fprintf("\n");

fprintf("Average response time\n");
fprintf("%f\n", averageSystemResponseTime);