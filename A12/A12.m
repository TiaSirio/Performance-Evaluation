clc, clear;

lambda = 50;
%lambda = 10;
%averageServiceTime = 0.085;
averageServiceTime = 0.015;
mu = 1 / averageServiceTime;
N = 6;
pOfExactIndexMinusOneJob = zeros(N + 1,1);
trafficIntensity = lambda * averageServiceTime;

for i = 0:N
    pOfExactIndexMinusOneJob(i + 1,1) = (1 - trafficIntensity) * (trafficIntensity)^i;
end

pOfHavingOneJob = pOfExactIndexMinusOneJob(2,1);

pOfHavingLessThanFourJob = pOfExactIndexMinusOneJob(1,1) + pOfExactIndexMinusOneJob(2,1) + pOfExactIndexMinusOneJob(3,1) + pOfExactIndexMinusOneJob(4,1);

U = trafficIntensity;

averageNOfJobSystem = (trafficIntensity / (1 - trafficIntensity));

averageResponseTime = averageServiceTime / (1 - trafficIntensity);

averageTimeSpentInQueue = (trafficIntensity * averageServiceTime) / (1 - trafficIntensity);

averageNOfJobNotInService = trafficIntensity^2 / (1 - trafficIntensity);

t = 0.5;
pOfResponseTimeGraterThanZeroDotFive = exp(-t/averageResponseTime);

percentile90 = -log(1 - 0.9) * averageResponseTime;

newLambda = 85;
numberOfServers = 2;
pOfExactIndexMinusOneJobMultipleServers = zeros(N + 1,1);
%pOfExactIndexMinusOneJobMultipleServersCheck = zeros(N + 1,1);
trafficIntensityMultipleServer = (newLambda * averageServiceTime)/numberOfServers;

pOfHavingZeroJobsMultipleServers = (1 - trafficIntensityMultipleServer) / (1 + trafficIntensityMultipleServer);
%pOfHavingZeroJobsMultipleServers = ((numberOfServers * mu) - newLambda) / ((numberOfServers * mu) + newLambda);
%pOfHavingZeroJobsMultipleServersCheck = (1 - trafficIntensityMultipleServer)/(1 + trafficIntensityMultipleServer);

pOfExactIndexMinusOneJobMultipleServers(1,1) = pOfHavingZeroJobsMultipleServers;

for i = 1:N
    %pOfExactIndexMinusOneJobMultipleServersCheck(i + 1,1) = numberOfServers * ((1 - trafficIntensityMultipleServer)/(1 + trafficIntensityMultipleServer)) * trafficIntensityMultipleServer^i;
    pOfExactIndexMinusOneJobMultipleServers(i + 1,1) = numberOfServers * ((1 - trafficIntensityMultipleServer)/(1 + trafficIntensityMultipleServer)) * trafficIntensityMultipleServer^i;
    %pOfExactIndexMinusOneJobMultipleServers(i + 1,1) = (numberOfServers * pOfHavingZeroJobsMultipleServers) * (newLambda / (numberOfServers * mu))^i;
end

pOfHavingOneJobMultipleServers = pOfExactIndexMinusOneJobMultipleServers(2,1);

pOfHavingLessThanFourJobMultipleServers = pOfExactIndexMinusOneJobMultipleServers(1,1) + pOfExactIndexMinusOneJobMultipleServers(2,1) + pOfExactIndexMinusOneJobMultipleServers(3,1) + pOfExactIndexMinusOneJobMultipleServers(4,1);

totalUMultipleServers = newLambda / mu;

averageUMultipleServers = newLambda / (numberOfServers * mu);

averageNOfJobSystemMultipleServers = (numberOfServers * trafficIntensityMultipleServer) / ((1 - trafficIntensityMultipleServer)^numberOfServers);

averageResponseTimeMultipleServers = averageServiceTime / (1 - (trafficIntensityMultipleServer^numberOfServers));

averageTimeSpentInQueueMultipleServers = ((trafficIntensityMultipleServer^numberOfServers) * averageServiceTime) / (1 - (trafficIntensityMultipleServer^numberOfServers));

averageNOfJobNotInService = averageTimeSpentInQueueMultipleServers * newLambda;