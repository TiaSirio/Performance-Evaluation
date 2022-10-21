clc, clear

filename = "random.csv";

table = readtable(filename);

table.Properties.VariableNames = ["discrete", "continuous1", "continuous2"];

sizeCDF = 500;

%% Continuous

aUnif = 5;
bUnif = 15;

resContinuous = zeros(sizeCDF, 1);

for i = 1:sizeCDF
    resContinuous(i) = aUnif + table.discrete(i) * (bUnif - aUnif);
end

range = aUnif:.001:bUnif;
CDFanalyticalUniform = cdf(makedist('Uniform','lower',aUnif,'upper',bUnif), range);

figure
plot(sort(resContinuous), (1:sizeCDF)/sizeCDF, "-b", range, CDFanalyticalUniform, "-r")



%% Discrete

probDiscrete = [0.3, 0.4, 0.3];
valueDiscrete = [5, 10, 15];


continuousDiscrete = cumsum(probDiscrete);

resDiscreteOccurrencies = zeros(1, 3);

for k = 1:sizeCDF
    if table.discrete(k) < continuousDiscrete(1,1)
        resDiscreteOccurrencies(1) = resDiscreteOccurrencies(1) + 1;
    elseif table.discrete(k) < continuousDiscrete(1,2)
        resDiscreteOccurrencies(2) = resDiscreteOccurrencies(2) + 1;
    else
        resDiscreteOccurrencies(3) = resDiscreteOccurrencies(3) + 1;
    end
end


resDiscrete = zeros(1, sizeCDF);
CDFDiscreteAnalytical = zeros(1, sizeCDF);

valueXAxe = zeros(1, sizeCDF);
for i = 1:sizeCDF
    valueXAxe(i) = i / 20;
    if valueXAxe(i) < 5
       resDiscrete(i) = 0;
       CDFDiscreteAnalytical(i) = 0;
    elseif valueXAxe(i) < 10
       resDiscrete(i) = resDiscreteOccurrencies(1) / sizeCDF;
       CDFDiscreteAnalytical(i) = 0.3;
    elseif valueXAxe(i) < 15
        resDiscrete(i) = (resDiscreteOccurrencies(2) + resDiscreteOccurrencies(1)) / sizeCDF;
        CDFDiscreteAnalytical(i) = 0.3 + 0.4;
    else
        resDiscrete(i) = 1;
        CDFDiscreteAnalytical(i) = 1;
    end
end


figure
plot(valueXAxe, sort(resDiscrete), "-b", valueXAxe ,sort(CDFDiscreteAnalytical), "-r")



%% Exponential
meanDiscrete = 10;
lambda = 1/meanDiscrete;

resExp = -log(table.continuous1) / lambda;

rangeExp = 0:80;
CDFanalyticalExponential = 1 - exp(-lambda * rangeExp);

figure
plot(sort(resExp), (1:sizeCDF)/sizeCDF, "-b", rangeExp, CDFanalyticalExponential, "-r");

%% Hyper-exponential
lambdaHyper = [0.05, 0.175];
probHyper = [0.3, 0.7];

resHyper = zeros(sizeCDF, 1);

rangeHyperExp = 0:80;

for k = 1:sizeCDF
    if table.discrete(k) < probHyper(1,1)
        resHyper(k) = -log(table.continuous1(k)) / lambdaHyper(1,1);
    else
        resHyper(k) = -log(table.continuous1(k)) / lambdaHyper(1,2);
    end
end

hyperExpAnalitycalFunc = @(p,t) (1 - (p(1,3) * exp(-p(1,1) * t)) - ((1 - p(1,3)) * exp(-p(1,2) * t)));

CDFHyperExpAnalytical = hyperExpAnalitycalFunc([lambdaHyper(1,1), lambdaHyper(1,2), probHyper(1,1)], rangeHyperExp);

figure
plot(sort(resHyper), (1:sizeCDF)/sizeCDF, "-b", rangeHyperExp, CDFHyperExpAnalytical, "-r");



%% Hypo-exponential
lambdaHypo = [0.25, 0.16667];

resHypo = -log(table.continuous1) / lambdaHypo(1,1) -log(table.continuous2) / lambdaHypo(1,2);

rangeHypoExp = 0:50;

CDFHypoExpAnalytical = 1 - (lambdaHypo(1,2) * (exp(-lambdaHypo(1,1) * rangeHypoExp)) - lambdaHypo(1,1) * exp(-lambdaHypo(1,2) * rangeHypoExp)) / (lambdaHypo(1,2) - lambdaHypo(1,1));

figure
plot(sort(resHypo), (1:sizeCDF)/sizeCDF, "-b", rangeHypoExp, CDFHypoExpAnalytical, "-r");


%% Hyper-Erlang

rateHyperErlang = [0.05, 0.35];
probHyperErlang = [0.3, 0.7];
cumSumErlang = cumsum(probHyperErlang);

rangeHyperErlang = (0:80);

resHyperErl = zeros(sizeCDF, 1);

for k = 1:sizeCDF
   resHyperErl(k) = 0;
   if table.discrete(k) < probHyperErlang(1,1)
       resHyperErl(k) = -log(table.continuous1(k)) / rateHyperErlang(1,1);
   else
     for stage = 1:2
        if stage == 1
            resHyperErl(k) = resHyperErl(k) - log(table.continuous1(k)) / rateHyperErlang(1,2);
        else
            resHyperErl(k) = resHyperErl(k) - log(table.continuous2(k)) / rateHyperErlang(1,2);
        end
     end
   end
end

resHyperErl2 = (table.discrete < probHyperErlang(1,1)) .* (-log(table.continuous1) / rateHyperErlang(1,1)) + (table.discrete >= probHyperErlang(1,1)) .* (-log(table.continuous1 .* table.continuous2) / rateHyperErlang(1,2));

CDFHyperErlang = @(x) 1 - probHyperErlang(1,1) .* exp(-rateHyperErlang(1,1) * x) - (1 - probHyperErlang(1,1)) .* (exp(-rateHyperErlang(1,2) * x) + rateHyperErlang(1,2) * x .* exp(-rateHyperErlang(1,2) * x));

figure
hold on
plot(sort(resHyperErl), (1:sizeCDF)/sizeCDF, ".b", "MarkerSize", 5);
plot(rangeHyperErlang, CDFHyperErlang(rangeHyperErlang), "-r");
plot(sort(resHyperErl2), (1:sizeCDF)/sizeCDF, ".y", "MarkerSize", 1);
