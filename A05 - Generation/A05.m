clc, clear

filename = "random.csv";

table = readtable(filename);

table.Properties.VariableNames = ["discrete", "continuous1", "continuous2"];

N = size(table, 1);

sizeCDF = 500;

%% Continuous

aUnif = 5;
bUnif = 15;

resContinuous = zeros(sizeCDF, 1);

for i = 1:sizeCDF
    resContinuous(i) = aUnif + table.discrete(i) * (bUnif - aUnif);
end

range = aUnif:.001:bUnif;
CDFanalyticalUniform = cdf(makedist('Uniform','lower',aUnif,'upper',bUnif),range);

figure
plot(sort(resContinuous), (1:N)/N, ".b", range, CDFanalyticalUniform, "-r")



%% Discrete

probDiscrete = [0.3, 0.4, 0.3];
valueDiscrete = [5, 10, 15];


continuousDiscrete = cumsum(probDiscrete);

resDiscrete = zeros(sizeCDF, 1);

for k = 1:sizeCDF
    if table.discrete(k) < continuousDiscrete(1,1)
        resDiscrete(k) = valueDiscrete(1,1);
    elseif table.discrete(k) < continuousDiscrete(1,2)
        resDiscrete(k) = valueDiscrete(1,2);
    else
        resDiscrete(k) = valueDiscrete(1,3);
    end
end

%figure
%plot(sort(resDiscrete), (1:N)/N, ".b")



%% Exponential
meanDiscrete = 10;
lambda = 1/meanDiscrete;

resExp = -log(table.continuous1) / lambda;

rangeExp = 0:80;
CDFanalyticalExponential = 1 - exp(-lambda * rangeExp);

figure
plot(sort(resExp), (1:N)/N, "b", rangeExp, CDFanalyticalExponential, "-r");

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
plot(sort(resHyper), (1:N)/N, ".b", rangeHyperExp, CDFHyperExpAnalytical, "-r");



%% Hypo-exponential
lambdaHypo = [0.25, 0.16667];

resHypo = -log(table.continuous1) / lambdaHypo(1,1) -log(table.continuous2) / lambdaHypo(1,2);

rangeHypoExp = 0:50;

CDFanal = 1 - (lambda2 * (exp(-lambda1 * rangeHypoExp)) - lambda1 * exp(-lambda2 * rangeHypoExp)) / (lambda2 - lambda1);

%figure
%plot(sort(resHypo), (1:N)/N, ".b");


%% Hyper-Erlang

numberOfStage = [1, 2];
rateHyperErlang = [0.05, 0.35];
probHyperErlang = [0.3, 0.7];

cumSumErlang = cumsum(probHyperErlang);

resHyperErl = zeros(sizeCDF, 1);

for k = 1:sizeCDF
    for i = 1:2
        if table.discrete(k) < probHyperErlang(1,i)
            resHyperErl(k) = 0;
            for l = 1:numberOfStage(1, i)
                if l == 1
                    resHyperErl(k) = resHyperErl(k) -log(table.continuous1(k)) / rateHyperErlang(1,i);
                else
                    resHyperErl(k) = resHyperErl(k) -log(table.continuous2(k)) / rateHyperErlang(1,i);
                end
            end
        end
    end
end

%figure
%plot(sort(resHyperErl), (1:N)/N, ".b");
