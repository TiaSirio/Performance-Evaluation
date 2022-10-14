clc, clear

filename = "Traces.csv";

table = readtable(filename);

table.Properties.VariableNames = ["operator1", "operator2", "operator3"];

tableSelected = table.operator1;
%tableSelected = table.operator2;
%tableSelected = table.operator3;

tableSelectedSorted = sortrows(tableSelected);

N = size(tableSelected, 1);

firstMoment = sum(tableSelected) / N;

secondMoment = sum(tableSelected .^2) / N;

thirdMoment = sum(tableSelected .^3) / N;

sigm = std(tableSelected);
coefficientOfVariation = sigm / firstMoment;


%Plot of CDF
%plot(tableSelectedSorted, (1:N)/N, "+b")
%legend('Data')


%Exponential distribution - Method of Moments
lambda_exp = 1  / firstMoment;

max_value = tableSelectedSorted(N);
max_value = ceil(max_value);

%variable from 0 to max of sorted table of CDF
t = (0:0.1:max_value);

yExp = 1 - exp(-lambda_exp * t);

%plot(tableSelectedSorted, (1:N)/N, "+b", t, yExp, "-y")
%legend('Data', 'Exponential distribution')


%Uniform distribution - Method of Moments
a_unif = firstMoment - 0.5 * sqrt(12 * (secondMoment - firstMoment .^ 2));
b_unif = firstMoment + 0.5 * sqrt(12 * (secondMoment - firstMoment .^ 2));

yUnif = max(0, min(1, (t - a_unif) / (b_unif - a_unif)));

%plot(tableSelectedSorted, (1:N)/N, "+b", t, yExp, "-y", t, yUnif, ".r")
%legend('Data', 'Exponential distribution', 'Uniform distribution')

%Hypo-exponential distribution - Method of Moments
if coefficientOfVariation < 1
    pars = [1/(0.3 * firstMoment), 1/(0.7 * firstMoment)];

    HypoExpMoments = @(p) [(1/p(1,1) + 1/p(1,2)), 2 * (1/p(1,1)^2 + 1/(p(1,1) * p(1,2) + 1/p(1,2)^2))];

    FunctionHypoExpM = @(p) (HypoExpMoments(p) ./ [firstMoment, secondMoment] - 1);

    resultOfHypoExpM = fsolve(FunctionHypoExpM, pars);
    clc

    HypoExpCDF = @(p,t) 1 - 1/(p(1,2) - p(1,1)) * (p(1,2) * exp(-p(1,1) * t) - p(1,1) * exp(-p(1,2) * t));

    yHypoExp = HypoExpCDF(resultOfHypoExpM, t);

    %plot(tableSelectedSorted, (1:N)/N, ".b", t, yExp, ".k", t, yUnif, ".r", t, yHypoExp, ".y")
    %legend('Data', 'Exponential distribution', 'Uniform distribution', 'Hypo-exponential distribution')
    
    %plot(tableSelectedSorted, (1:N)/N, "+b", t, yExp, "-c", t, yUnif, ".r", t, yHypoExp, "xy")
    %plot(tableSelectedSorted, (1:N)/N, t, yExp, t, yUnif, t, yHypExp)
end

%Hyper-exponential distribution - Method of Moments
if coefficientOfVariation > 1
    lam = [1/(0.8 * firstMoment), 1/(1.2 * firstMoment)];
    prob = 0.4;

    HyperExpMoments = @(p, t) [t/p(1,1) + (1-t)/p(1,2), 2 * (t/(p(1,1)^2) + (1-t)/(p(1,2)^2)), 6 * (t/(p(1,1)^3) + ((1-t)/(p(1,2)^2)))];
    FunctionHyperEM = @(p) (HyperExpMoments(p(1, 1:2), p(1,3)) ./ [firstMoment, secondMoment, thirdMoment] - 1);
    
    var = [lam(1,1), lam(1,2), prob];

    resultsOfHyperExpM = fsolve(FunctionHyperEM, var);
    clc

    HyperExpCDF = @(p, t) 1 - p(1,3) * exp(-p(1,1) * t) - (1 - p(1,3)) * exp(-p(1,2) * t);
    y2HyperExpM = HyperExpCDF(resultsOfHyperExpM, t);

    %plot(tableSelectedSorted, (1:N)/N, ".b", t, yExp, ".k", t, yUnif, ".r", t, y2HyperExpM, ".y")
    %legend('Data', 'Exponential distribution', 'Uniform distribution', 'Hyper-exponential distribution')
end



%Exponential distribution - Maximhood likelihood
ExpPDF = @(x, l) (l * exp(-l * x));

yExpML = mle(tableSelected, 'pdf', ExpPDF, 'Start', 1/firstMoment);

yExpMLEGraph = 1 - exp(-yExpML * t);

%plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpMLEGraph, ".k")
%legend('Data', 'Exponential distribution')


%Hypo-exponential distribution - Maximhood likelihood
if coefficientOfVariation < 1
    HypoExpPDF = @(x, l1, l2) (l1 * l2 / (l1 - l2) * (exp(-x * l2) - exp(-x * l1)));

    yHypoExpMLE = mle(tableSelected, 'pdf', HypoExpPDF, 'Start', [1/(0.3 * firstMoment), 1/(0.7 * firstMoment)]);

    yHypoExpMMLEGraph = HypoExpCDF(yHypoExpMLE, t);

    %plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpMLEGraph, ".k", t, yHypoExpMMLEGraph, ".g")
    %legend('Data', 'Exponential distribution', 'Hypo-exponential distribution')
end


%Hyper-exponential distribution - Maximhood likelihood
if coefficientOfVariation > 1
    HyperExpPDF = @(x, l1, l2, p) (p * l1 * exp(-l1 * x) + (1 - p) * l2 * exp(-l2 * x));

    yHyperExpMLE = mle(tableSelected, 'pdf', HyperExpPDF, 'Start', [0.8 / firstMoment, 1.2 / firstMoment, 0.4]);

    yHyperExpMLEGraph = HyperExpCDF(yHyperExpMLE, t);

    %plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpMLEGraph, ".k", t, yHyperExpMLEGraph, ".m")
    %legend('Data', 'Exponential distribution', 'Hyper-exponential distribution')
end