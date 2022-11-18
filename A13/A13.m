clc, clear;

%% M/M/1/16

lambda = 1200;
%lambda = 0.9;
averageServiceTime = 0.00125;
%averageServiceTime = 1;
mu = 1 / averageServiceTime;
finalCapacity = 16;
%finalCapacity = 6;

trafficIntensity = lambda/mu;

pOfHavingZeroPackets = (1 - trafficIntensity) / (1 - (trafficIntensity^(finalCapacity + 1)));

pOfExactIndexMinusOnePackets = zeros(finalCapacity + 1,1);

pOfExactIndexMinusOnePackets(1,1) = pOfHavingZeroPackets;

for i = 1:finalCapacity
    pOfExactIndexMinusOnePackets(i + 1) = pOfHavingZeroPackets * (trafficIntensity^i);
end

%pOfHaving14Packets = pOfHavingZeroPackets * (trafficIntensity^14);
pOfHaving14Packets = pOfExactIndexMinusOnePackets(15,1);
%pOfHaving4Packets = pOfExactIndexMinusOnePackets(5,1);

U = 1 - pOfHavingZeroPackets;

averageN = (trafficIntensity/(1 - trafficIntensity)) - ((finalCapacity + 1) * (trafficIntensity^(finalCapacity + 1)))/(1 - (trafficIntensity^(finalCapacity + 1)));

pOfHavingTheSystemFull = ((trafficIntensity^(finalCapacity)) - (trafficIntensity^(finalCapacity + 1)))/(1 - (trafficIntensity^(finalCapacity + 1)));

dropRate = lambda * pOfHavingTheSystemFull;

throughput = lambda - dropRate;

averageResponseTime = averageN/(lambda * (1 - pOfHavingTheSystemFull));

averageTimeSpentInQueue = averageResponseTime - averageServiceTime;

%% M/M/2/16

numberOfServers = 2;
lambdaMultipleServers = 1200;
%lambdaMultipleServers = 1.8;

trafficIntensityMultipleServers = (lambdaMultipleServers * averageServiceTime) / numberOfServers;

valueForP0 = 0;

for i = 0:numberOfServers - 1
    valueForP0 = valueForP0 + (((numberOfServers * trafficIntensityMultipleServers)^i)/factorial(i));
end

pOfHavingZeroPacketsMultipleServers = ((((numberOfServers * trafficIntensityMultipleServers)^numberOfServers)/factorial(numberOfServers)) * ((1 - (trafficIntensityMultipleServers^(finalCapacity - numberOfServers + 1)))/(1 - trafficIntensityMultipleServers)) + valueForP0)^-1;

pOfExactIndexMinusOnePacketsMultipleServers = zeros(finalCapacity + 1,1);

pOfExactIndexMinusOnePacketsMultipleServers(1,1) = pOfHavingZeroPacketsMultipleServers;

for i = 1:finalCapacity
    if i < numberOfServers
        pOfExactIndexMinusOnePacketsMultipleServers(i + 1) = (pOfHavingZeroPacketsMultipleServers/factorial(i)) * (numberOfServers * trafficIntensityMultipleServers)^i;
    else
        pOfExactIndexMinusOnePacketsMultipleServers(i + 1) = (pOfHavingZeroPacketsMultipleServers * (numberOfServers^numberOfServers) * (trafficIntensityMultipleServers^i)/factorial(numberOfServers));
    end
end

pOfHaving14PacketsMultipleServers = pOfExactIndexMinusOnePacketsMultipleServers(15,1);
%pOfHaving4PacketsMultipleServers = pOfExactIndexMinusOnePacketsMultipleServers(5,1);

averageNMultipleServers = 0;

for i = 1:finalCapacity
    averageNMultipleServers = averageNMultipleServers + (i * pOfExactIndexMinusOnePacketsMultipleServers(i + 1));
end

averageUMultipleServers = 0;

for i = 1:numberOfServers
    averageUMultipleServers = averageUMultipleServers + (i * pOfExactIndexMinusOnePacketsMultipleServers(i + 1));
end

valueForAverage = 0;

for i = (numberOfServers + 1):finalCapacity
    valueForAverage = valueForAverage + pOfExactIndexMinusOnePacketsMultipleServers(i + 1);
end

averageUMultipleServers = averageUMultipleServers + numberOfServers * valueForAverage;
averageUMultipleServers = averageUMultipleServers/numberOfServers;

%Same operation as to M/M/1/16
pOfHavingTheSystemFullMultipleServers = pOfExactIndexMinusOnePacketsMultipleServers(end,1); %((trafficIntensityMultipleServers^(finalCapacity)) - (trafficIntensityMultipleServers^(finalCapacity + 1)))/(1 - (trafficIntensityMultipleServers^(finalCapacity + 1)));

%Same operation as to M/M/1/16
dropRateMultipleServers = lambdaMultipleServers * pOfHavingTheSystemFullMultipleServers;

%Same operation as to M/M/1/16
throughputMultipleServers = lambdaMultipleServers - dropRateMultipleServers;

averageResponseTimeMultipleServers = averageNMultipleServers/(lambdaMultipleServers * (1 - pOfHavingTheSystemFullMultipleServers));

averageTimeSpentInQueueMultipleServers = averageResponseTimeMultipleServers - averageServiceTime;

fprintf("%f\n", U);
fprintf("%f\n", pOfHaving14Packets);
%fprintf("%f\n", pOfHaving4Packets);
fprintf("%f\n", averageN);
fprintf("%f\n", throughput);
fprintf("%f\n", dropRate);
fprintf("%f\n", averageResponseTime);
fprintf("%f\n", averageTimeSpentInQueue);

fprintf("\n\n");

fprintf("%f\n", averageUMultipleServers);
fprintf("%f\n", pOfHaving14PacketsMultipleServers);
%fprintf("%f\n", pOfHaving4PacketsMultipleServers);
fprintf("%f\n", averageNMultipleServers);
fprintf("%f\n", throughputMultipleServers);
fprintf("%f\n", dropRateMultipleServers);
fprintf("%f\n", averageResponseTimeMultipleServers);
fprintf("%f\n", averageTimeSpentInQueueMultipleServers);