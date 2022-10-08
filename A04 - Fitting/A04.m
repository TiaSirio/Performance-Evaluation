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
    pars = [1, 2];

    HypExpMoments = @(p) [(1/p(1,1) + 1/p(1,2)), 2 * (1/p(1,1)^2 + 1/(p(1,1) * p(1,2) + 1/p(1,2)^2))];

    FunctionHEM = @(p) (HypExpMoments(p) ./ [firstMoment, secondMoment] - 1);

    resultOfHEM = fsolve(FunctionHEM, pars);
    clc

    HypExpCDF = @(p,t) 1 - 1/(p(1,2) - p(1,1)) * (p(1,2) * exp(-p(1,1) * t) - p(1,1) * exp(-p(1,2) * t));

    yHypExp = HypExpCDF(resultOfHEM, t);

    %plot(tableSelectedSorted, (1:N)/N, "+b", t, yExp, "-c", t, yUnif, ".r", t, yHypExp, "xy")
    %plot(tableSelectedSorted, (1:N)/N, ".b", t, yExp, ".k", t, yUnif, ".r", t, yHypExp, ".y")
    %legend('Data', 'Exponential distribution', 'Uniform distribution', 'Hypo-exponential distribution')
    %plot(tableSelectedSorted, (1:N)/N, t, yExp, t, yUnif, t, yHypExp)
end

%{
%Hyper-exponential distribution - Method of Moments
if coefficientOfVariation > 1
    lam = [1,2];
    prob = [0.4, 0.6];

    HyperExpMoments = @(l, p) [(p(1,1) / l(1,1)) + ((1 - p(1,1)) / l(1,2)), 2 * (p(1,1) / l(1,1)^2) + ((1 - p(1,1)) / l(1,2)^2)];

    FunctionHyEM = @(l, p) (HyperExpMoments(l, p) ./ [firstMoment, secondMoment] - 1);

    resultOfHyEM = fsolve(FunctionHyEM, [lam, prob]);
    clc

    HyperExpCDF = @(l, p, t) 1 - sum(p * exp(-l * t));

    yHyperExp = HyperExpCDF(resultOfHyEM, t);

    plot(tableSelectedSorted, (1:N)/N, ".b", t, yExp, ".k", t, yUnif, ".r", t, yHypExp, ".y", t, yHyperExp, ".m")
    legend('Data', 'Exponential distribution', 'Uniform distribution', 'Hypo-exponential distribution', 'Hyper-exponential distribution')
end
%}



%Exponential with Maximhood likelihood
ExpPDF = @(x, l) (l * exp(-l * x));

yExpML = mle(tableSelected, 'pdf', ExpPDF, 'Start', 0.5);

%plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpML, ".k")
%legend('Data', 'Exponential distribution')


%Hypo-exponential with Maximhood likelihood
HypExpPDF = @(x, l1, l2) (l1 * l2 / (l1 - l2) * (exp(-x * l2) - exp(-x * l1)));

yHypExpML = mle(tableSelected, 'pdf', HypExpPDF, 'Start', [1/(0.3 * firstMoment), 1/(0.7 * firstMoment)]);
%result = mle(tableSelected, 'pdf', HypExpPDF, 'Start', [1,10], 'LowerBound', [0.000001, 0.000001]);

%plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpML, ".k", t, yHypExpML, ".g")
%legend('Data', 'Exponential distribution', 'Hypo-exponential distribution')


%Hyper-exponential with Maximhood likelihood
HyperExpPDF = @(x, l1, l2, p) (p * l1 * exp(-l1 * x) + (1 - p) * l2 * exp(-l2 * x));

yHyperExpML = mle(tableSelected, 'pdf', HyperExpPDF, 'Start', [0.8 / firstMoment, 1.2 / firstMoment, 0.4]);

%plot(tableSelectedSorted, (1:N)/N, ".b", t, yExpML, ".k", t, yHypExpML, ".g", t, yHyperExpML, ".m")
%legend('Data', 'Exponential distribution', 'Hypo-exponential distribution', 'Hyper-exponential distribution')
