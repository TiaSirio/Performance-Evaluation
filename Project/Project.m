%% INTRO
clc, clear

namesOfDepartments = ["Spec", "Design", "Breadbrd", "Software", "Test"];
namesOfDepartments = string(namesOfDepartments);

fileOrigin = "Traces/TraceC-";
fileFinalPart = ".txt";

%duration = zeros(size(namesOfDepartments));

for col = 1:size(namesOfDepartments, 2)
    file = strcat(fileOrigin, namesOfDepartments(col), fileFinalPart);
    duration(:,col) = array2table(csvread(file));
end

duration.Properties.VariableNames = namesOfDepartments;

N = size(duration, 1);

%% SPEC

durationSpec = sortrows(duration.Spec);
sigmaSpec = std(durationSpec);
firstMomentSpec = sum(durationSpec) / N;
coefficientOfVariationSpec = sigmaSpec / firstMomentSpec;
maxValueSpec = max(durationSpec);
maxValueSpec = ceil(maxValueSpec);
tSpec = (0:0.1:maxValueSpec);

kSpec = round(1/(coefficientOfVariationSpec^2));
lambdaSpec = kSpec / firstMomentSpec;
yErlangSpecCDF = 1;
for stageSpec = 0:kSpec - 1
    yErlangSpecCDF = yErlangSpecCDF - ((exp(-lambdaSpec * tSpec) .* (lambdaSpec * tSpec) .^ stageSpec) / (factorial(stageSpec)));
end
%kSpec = 1/(coefficientOfVariationSpec)^2;
%thetaSpec = firstMomentSpec/kSpec;
%yGammaSpecCDF = gamcdf(tSpec, kSpec, thetaSpec);

figure;
plot(durationSpec, (1:N)/N, ".b", tSpec, yErlangSpecCDF', "y");
%plot(durationSpec, (1:N)/N, "b", tSpec, yGammaSpecCDF', "y");
legend("Erlang - ", namesOfDepartments(1));
title("Best fitting: " + namesOfDepartments(1));

%% DESIGN

durationDesign = sortrows(duration.Design);
sigmaDesign = std(durationDesign);
firstMomentDesign = sum(durationDesign) / N;
coefficientOfVariationDesign = sigmaDesign / firstMomentDesign;
maxValueDesign = max(durationDesign);
maxValueDesign = ceil(maxValueDesign);
tDesign = (0:0.1:maxValueDesign);

kDesign = round(1/(coefficientOfVariationDesign^2));
lambdaDesign = kDesign / firstMomentDesign;
yErlangDesignCDF = 1;
for stageDesign = 0:kDesign - 1
    yErlangDesignCDF = yErlangDesignCDF - ((exp(-lambdaDesign * tDesign) .* (lambdaDesign * tDesign) .^ stageDesign) / (factorial(stageDesign)));
end
%kDesign = 1/(coefficientOfVariationDesign)^2;
%thetaDesign = firstMomentDesign/kDesign;
%yGammaDesignCDF = gamcdf(tDesign, kDesign, thetaDesign);

figure;
plot(durationDesign, (1:N)/N, ".b", tDesign, yErlangDesignCDF', "y");
%plot(durationSpec, (1:N)/N, "b", tSpec, yGammaDesignCDF', "y");
legend("Erlang - ", namesOfDepartments(2));
title("Best fitting: " + namesOfDepartments(2));

%% BREADBOARD

durationBreadboard = sortrows(duration.Breadbrd);

sigmaBreadboard = std(durationBreadboard);
firstMomentBreadboard = sum(durationBreadboard) / N;
secondMomentBreadboard = sum(durationBreadboard .^2) / N;
thirdMomentBreadboard = sum(durationBreadboard .^3) / N;

coefficientOfVariationBreadboard = sigmaBreadboard / firstMomentBreadboard;

maxValueBreadboard = max(durationBreadboard);
maxValueBreadboard = ceil(maxValueBreadboard);
tBreadboard = (0:0.1:maxValueBreadboard);

MomentsHyperExpBreadboard = @(p, t) [t/p(1,1) + (1-t)/p(1,2), 2 * (t/(p(1,1)^2) + (1-t)/(p(1,2)^2)), 6 * (t/(p(1,1)^3) + ((1-t)/(p(1,2)^3)))];
FunctionHyperExpBreadboard = @(p) (MomentsHyperExpBreadboard(p(1, 1:2), p(1,3)) ./ [firstMomentBreadboard, secondMomentBreadboard, thirdMomentBreadboard] - 1);

if coefficientOfVariationBreadboard > 1
    lambdaBreadboard = [(0.8 / firstMomentBreadboard), (1.2 / firstMomentBreadboard)];
    pBreadboard = 0.4;
    varBreadboard = [lambdaBreadboard(1,1), lambdaBreadboard(1,2), pBreadboard];

    resBreadboard = fsolve(FunctionHyperExpBreadboard, varBreadboard);
    clc

    pBreadboard = resBreadboard(3);
    lambdaBreadboard = resBreadboard(1:2);
    
    HyperExpBreadboardCDF = @(p, t) 1 - p(1,3) * exp(-p(1,1) * t) - (1 - p(1,3)) * exp(-p(1,2) * t);
    yHyperExpBreadboard = HyperExpBreadboardCDF(resBreadboard, tBreadboard);

    figure
    plot(durationBreadboard, (1:N)/N, "b", tBreadboard, yHyperExpBreadboard, "y");
    legend("Hyper-exponential - ", namesOfDepartments(3));
    title("Best fitting: " + namesOfDepartments(3));
end

%% SOFTWARE

durationSoftware = sortrows(duration.Software);

sigmaSoftware = std(durationSoftware);
firstMomentSoftware = sum(durationSoftware) / N;
secondMomentSoftware = sum(durationSoftware .^2) / N;
thirdMomentSoftware = sum(durationSoftware .^3) / N;

coefficientOfVariationSoftware = sigmaSoftware / firstMomentSoftware;

maxValueSoftware = max(durationSoftware);
maxValueSoftware = ceil(maxValueSoftware);
tSoftware = (0:0.1:maxValueSoftware);

MomentsHyperExpSoftware = @(p, t) [t/p(1,1) + (1-t)/p(1,2), 2 * (t/(p(1,1)^2) + (1-t)/(p(1,2)^2)), 6 * (t/(p(1,1)^3) + ((1-t)/(p(1,2)^3)))];
FunctionHyperExpSoftware = @(p) (MomentsHyperExpSoftware(p(1, 1:2), p(1,3)) ./ [firstMomentSoftware, secondMomentSoftware, thirdMomentSoftware] - 1);

if coefficientOfVariationSoftware > 1
    lambdaSoftware = [(0.8 / firstMomentSoftware), (1.2 / firstMomentSoftware)];
    pSoftware = 0.4;
    varSoftware = [lambdaSoftware(1,1), lambdaSoftware(1,2), pSoftware];

    resSoftware = fsolve(FunctionHyperExpSoftware, varSoftware);
    clc

    pSoftware = resSoftware(3);
    lambdaSoftware = resSoftware(1:2);

    HyperExpSoftwareCDF = @(p, t) 1 - p(1,3) * exp(-p(1,1) * t) - (1 - p(1,3)) * exp(-p(1,2) * t);
    yHyperExpSoftware = HyperExpSoftwareCDF(resSoftware, tSoftware);

    figure
    plot(durationSoftware, (1:N)/N, "b", tSoftware, yHyperExpSoftware, "y");
    legend("Hyper-exponential - ", namesOfDepartments(4));
    title("Best fitting: " + namesOfDepartments(4));
end


%% TEST

durationTest = sortrows(duration.Test);

firstMomentTest = sum(durationTest) / N;
lambdaTest = 1  / firstMomentTest;

maxValueTest = max(durationTest);
maxValueTest = ceil(maxValueTest);
tTest = (0:0.1:maxValueTest);
yExpTest = 1 - exp(-lambdaTest * tTest);

figure;
plot(durationTest, (1:N)/N, "b", tTest, yExpTest', "y");
legend("Exponential - ", namesOfDepartments(5));
title("Best fitting: " + namesOfDepartments(5));


%% Tests

for i = 1:length(namesOfDepartments)
    % Setup
    durationTemp = sortrows(table2array(duration(:, i)));
    sigma = std(durationTemp);
    firstMoment = sum(durationTemp) / N;
    secondMoment = sum(durationTemp .^2) / N;
    thirdMoment = sum(durationTemp .^3) / N;
    coefficientOfVariation = sigma / firstMoment;
    maxValue = max(durationTemp);
    maxValue = ceil(maxValue);
    t = (0:0.1:maxValue);

    % Uniform
    a_unif = firstMoment - 0.5 * sqrt(12 * (secondMoment - firstMoment .^ 2));
    b_unif = firstMoment + 0.5 * sqrt(12 * (secondMoment - firstMoment .^ 2));

    yUnif = max(0, min(1, (t - a_unif) / (b_unif - a_unif)));

    % Exponential
    lambda_exp = 1  / firstMoment;
    yExp = 1 - exp(-lambda_exp * t);

    % Erlang
    k = round(1/(coefficientOfVariation^2));
    lambda = k / firstMoment;

    yErlangCDF = 1;
    for stage = 0:k - 1
        yErlangCDF = yErlangCDF - ((exp(-lambda * t) .* (lambda * t) .^ stage) / (factorial(stage)));
    end

    % Gamma
    k = 1/(coefficientOfVariation)^2;
    theta = firstMoment/k;
    yGammaCDF = gamcdf(t, k, theta);

    % Hypo-exponential
    if coefficientOfVariation < 1
        pars = [1/(0.3 * firstMoment), 1/(0.7 * firstMoment)];

        HypoExpMoments = @(p) [(1/p(1,1) + 1/p(1,2)), 2 * (1/p(1,1)^2 + 1/(p(1,1) * p(1,2)) + 1/p(1,2)^2)];

        FunctionHypoExpM = @(p) (HypoExpMoments(p) ./ [firstMoment, secondMoment] - 1);

        resultOfHypoExpM = fsolve(FunctionHypoExpM, pars);
        clc

        HypoExpCDF = @(p, t) 1 - 1/(p(1,2) - p(1,1)) * (p(1,2) * exp(-p(1,1) * t) - p(1,1) * exp(-p(1,2) * t));

        yHypoExp = HypoExpCDF(resultOfHypoExpM, t);

        if lambda > 0
            % Figure
            figure
            plot(durationTemp, (1:N)/N, ".b", t, yUnif, "r", t, yExp, "k", t, yHypoExp, "y", t, yGammaCDF, "c", t, yErlangCDF, "m")
            legend('Data', 'Uniform distribution', 'Exponential distribution', 'Hypo-exponential distribution', 'Gamma distribution', 'Erlang')
            title("Fittings: " + namesOfDepartments(i))
        else
            % Figure
            figure
            plot(durationTemp, (1:N)/N, ".b", t, yUnif, "r", t, yExp, "k", t, yHypoExp, "y", t, yGammaCDF, "c")
            legend('Data', 'Uniform distribution', 'Exponential distribution', 'Hypo-exponential distribution', 'Gamma distribution')
            title("Fittings: " + namesOfDepartments(i))
        end
        
    end

    % Hyper-exponential
    if coefficientOfVariation > 1
        lam = [(0.8 / firstMoment), (1.2 / firstMoment)];
        prob = 0.4;

        HyperExpMoments = @(p, t) [t/p(1,1) + (1-t)/p(1,2), 2 * (t/(p(1,1)^2) + (1-t)/(p(1,2)^2)), 6 * (t/(p(1,1)^3) + ((1-t)/(p(1,2)^3)))];
        FunctionHyperEM = @(p) (HyperExpMoments(p(1, 1:2), p(1,3)) ./ [firstMoment, secondMoment, thirdMoment] - 1);
    
        var = [lam(1,1), lam(1,2), prob];

        resultsOfHyperExpM = fsolve(FunctionHyperEM, var);
        clc

        HyperExpCDF = @(p, t) 1 - p(1,3) * exp(-p(1,1) * t) - (1 - p(1,3)) * exp(-p(1,2) * t);
        yHyperExpM = HyperExpCDF(resultsOfHyperExpM, t);

        if lambda > 0
            % Figure
            figure
            plot(durationTemp, (1:N)/N, ".b", t, yUnif, "r", t, yExp, "k", t, yHyperExpM, "y", t, yGammaCDF, "c", t, yErlangCDF, "m")
            legend('Data', 'Uniform distribution', 'Exponential distribution', 'Hyper-exponential distribution', 'Gamma distribution', 'Erlang')
            title("Fittings: " + namesOfDepartments(i))
        else
            % Figure
            figure
            plot(durationTemp, (1:N)/N, ".b", t, yUnif, "r", t, yExp, "k", t, yHyperExpM, "y", t, yGammaCDF, "c")
            legend('Data', 'Uniform distribution', 'Exponential distribution', 'Hyper-exponential distribution', 'Gamma distribution')
            title("Fittings: " + namesOfDepartments(i))
        end
    end
end