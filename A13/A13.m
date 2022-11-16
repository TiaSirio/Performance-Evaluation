clc, clear;

lambda = 1200;
averageServiceTime = 0.00125;
mu = 1 / averageServiceTime;
numberOfServers = 1;
finalCapacity = 16;

trafficIntensity = lambda/mu;

U = zeros;

for i = 1:finalCapacity
    
end