clc, clear;

lambda = 500;
rateHypo = [1500, 1000];
%{
rangeHypoExp = 0:50;

hypoExp = 1 - (rateHypo(1,2) * (exp(-rateHypo(1,1) * rangeHypoExp)) - rateHypo(1,1) * exp(-rateHypo(1,2) * rangeHypoExp)) / (rateHypo(1,2) - rateHypo(1,1));

duration = mean(hypoExp);

secondMoment = mean(hypoExp.^2);

trafficIntensity = lambda * duration;

remainingTime = (lambda * secondMoment)/2;

averageResponseTime = duration + ((lambda * secondMoment)/(2 * (1 - trafficIntensity)));

averageN = trafficIntensity + (((lambda^2) * secondMoment)/(2 * (1 - trafficIntensity)));

variance = secondMoment - (duration^2);

coefficientOfVariation = variance/(duration^2);

averageTimeSpentInQueue = (trafficIntensity * duration)/(1 - trafficIntensity);
%}

averageInterArrivalT = 1/lambda;