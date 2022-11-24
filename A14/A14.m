clc, clear;

%% First point

lambdaPoisson = 500;
rateHypo = [1500, 1000];

mean = (1/rateHypo(1,1)) + (1/rateHypo(1,2));
standardDeviation = (1/rateHypo(1,1)^2) + (1/rateHypo(1,2)^2);
coefficientOfVariation = sqrt((rateHypo(1,1)^2) + (rateHypo(1,2)^2))/(rateHypo(1,1) + rateHypo(1,2));
duration = mean;
secondMoment = 2 * ((1/(rateHypo(1,1)^2)) + (1/(rateHypo(1,1) * rateHypo(1,2))) + (1/(rateHypo(1,2)^2)));

trafficIntensity = lambdaPoisson * duration;

remainingTime = (lambdaPoisson * secondMoment)/2;

exactResponseTime = duration + ((lambdaPoisson * secondMoment)/(2 * (1 - trafficIntensity)));

exactAverageN = trafficIntensity + (((lambdaPoisson^2) * secondMoment)/(2 * (1 - trafficIntensity)));

averageU = lambdaPoisson * duration;

%variance = secondMoment - (duration^2);

%coefficientOfVariation2 = variance/(duration^2);

%averageTimeSpentInQueue = (trafficIntensity * duration)/(1 - trafficIntensity);


%% G/G/2

numberOfStageErlang = 4;
lambdaErlang = 4000;

meanErlang = numberOfStageErlang/lambdaErlang;
standardDeviationErlang = numberOfStageErlang/(lambdaErlang^2);
coefficientOfVariationErlang = 1/(sqrt(numberOfStageErlang));
durationMultipleServers = duration;

averageInterArrivalT = 1/meanErlang;

trafficIntensityMultipleServers = durationMultipleServers/(2 * averageInterArrivalT);

exactAverageUMultipleServers = meanErlang * durationMultipleServers;
%exactAverageUMultipleServers = (lambdaErlang * (durationMultipleServers / 2))/2;
%exactAverageUMultipleServers = lambdaErlang * durationMultipleServers;

exactAverageResponseTimeMultipleServers = durationMultipleServers + (((coefficientOfVariation^2) + (coefficientOfVariationErlang^2))/2) * (((trafficIntensityMultipleServers^2) * durationMultipleServers)/(1 - (trafficIntensityMultipleServers^2)));
exactAverageNMultipleServers = trafficIntensityMultipleServers + (((trafficIntensityMultipleServers^2) * ((coefficientOfVariation^2) + (coefficientOfVariationErlang^2)))/(2 * (1 - trafficIntensityMultipleServers)));
%exactAverageNMultipleServers = meanErlang * exactAverageResponseTimeMultipleServers;

fprintf("%f\n", averageU);
fprintf("%f\n", exactResponseTime);
fprintf("%f\n", exactAverageN);
fprintf("\n");
fprintf("%f\n", exactAverageUMultipleServers);
fprintf("%f\n", exactAverageResponseTimeMultipleServers);
fprintf("%f\n", exactAverageNMultipleServers);