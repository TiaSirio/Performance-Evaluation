clc, clear

filename = "Data1.txt";
filename2 = "Data2.txt";
filename3 = "Data3.txt";
filename4 = "Data4.txt";

log = readtable(filename);
%log = readtable(filename2);
%log = readtable(filename3);
%log = readtable(filename4);

table = log(:,1);

table.Properties.VariableNames = "data";

tableSorted = sortrows(table(:,1));

N = size(table, 1);

plot(tableSorted.data, (1:N)/N, "+b");

EX = sum(table.data) / N;

secondMoment = sum(table.data .^2) / N;

thirdMoment = sum(table.data .^3) / N;

fourthMoment = sum(table.data .^4) / N;

fifthMoment = sum(table.data .^5) / N;

secondCenteredMoment = sum((table.data - EX) .^2) / N;

thirdCenteredMoment = sum((table.data - EX) .^3) / N;

fourthCenteredMoment = sum((table.data - EX) .^4) / N;

fifthCenteredMoment = sum((table.data - EX) .^5) / N;

sigm = sqrt(sum((table.data - EX) .^2) / N);

thirdStandardizedMoment = sum(((table.data - EX) ./ sigm) .^3) / N;

fourthStandardizedMoment = sum(((table.data - EX) ./ sigm) .^4) / N;

fifthStandardizedMoment = sum(((table.data - EX) ./ sigm) .^5) / N;

std = std(table.data);

skewness = skewness(table.data);

kurtosis = kurtosis(table.data) - 3;

coefficientOfVariation = sigm / EX;

h10 = (N - 1) * 10 / 100 + 1;
h25 = (N - 1) * 25 / 100 + 1;
h50 = (N - 1) * 50 / 100 + 1;
h75 = (N - 1) * 75 / 100 + 1;
h90 = (N - 1) * 90 / 100 + 1;

percentile10 = tableSorted.data(floor(h10), 1) + (h10 - floor(h10)) * (tableSorted.data(floor(h10) + 1, 1) - tableSorted.data(floor(h10), 1));
percentile25 = tableSorted.data(floor(h25), 1) + (h25 - floor(h25)) * (tableSorted.data(floor(h25) + 1, 1) - tableSorted.data(floor(h25), 1));
percentile50 = tableSorted.data(floor(h50), 1) + (h50 - floor(h50)) * (tableSorted.data(floor(h50) + 1, 1) - tableSorted.data(floor(h50), 1));
percentile75 = tableSorted.data(floor(h75), 1) + (h75 - floor(h75)) * (tableSorted.data(floor(h75) + 1, 1) - tableSorted.data(floor(h75), 1));
percentile90 = tableSorted.data(floor(h90), 1) + (h90 - floor(h90)) * (tableSorted.data(floor(h90) + 1, 1) - tableSorted.data(floor(h90), 1));

lag1 = sum((table.data(1:end - 1, :) - EX) .* (table.data(2:end, :) - EX)) / (N - 1);
lag2 = sum((table.data(1:end - 2, :) - EX) .* (table.data(3:end, :) - EX)) / (N - 2);
lag3 = sum((table.data(1:end - 3, :) - EX) .* (table.data(4:end, :) - EX)) / (N - 3);

PearsonCorrelationCoefficient1 = sum((table.data(1:end - 1, :) - EX) .* (table.data(2:end, :) - EX)) / (N - 1) ./ (sigm .^ 2);
PearsonCorrelationCoefficient2 = sum((table.data(1:end - 2, :) - EX) .* (table.data(3:end, :) - EX)) / (N - 2) ./ (sigm .^ 2);
PearsonCorrelationCoefficient3 = sum((table.data(1:end - 3, :) - EX) .* (table.data(4:end, :) - EX)) / (N - 3) ./ (sigm .^ 2);

percentile10Check = prctile(table2array(tableSorted), 10);
if (round(percentile10Check,3) ~= round(percentile10,3))
    error("Percentile10 not corrispondent!")
end

percentile25Check = prctile(table2array(tableSorted), 25);
if (round(percentile25Check,3) ~= round(percentile25,3))
    error("Percentile25 not corrispondent!")
end

percentile50Check = prctile(table2array(tableSorted), 50);
if (round(percentile50Check,3) ~= round(percentile50,3))
    error("Percentile50 not corrispondent!")
end

percentile75Check = prctile(table2array(tableSorted), 75);
if (round(percentile75Check,2) ~= round(percentile75,2))
    error("Percentile75 not corrispondent!")
end

percentile90Check = prctile(table2array(tableSorted), 90);
if (round(percentile90Check,2) ~= round(percentile90,2))
    error("Percentile90 not corrispondent!")
end



fprintf(1, "EX:")
EX
fprintf(1, "Second moment:")
secondMoment
fprintf(1, "Third moment:")
thirdMoment
fprintf(1, "Fourth moment:")
fourthMoment
fprintf(1, "Fifth moment:")
fifthMoment
fprintf(1, "Second centered moment:")
secondCenteredMoment
fprintf(1, "Third centered moment:")
thirdCenteredMoment
fprintf(1, "Fourth centered moment:")
fourthCenteredMoment
fprintf(1, "Fifth centered moment:")
fifthCenteredMoment
fprintf(1, "Third Standardized moment:")
thirdStandardizedMoment
fprintf(1, "Fourth Standardized moment:")
fourthStandardizedMoment
fprintf(1, "Fifth Standardized moment:")
fifthStandardizedMoment
fprintf(1, "Standard deviation:")
std
fprintf(1, "Coefficient of variation:")
coefficientOfVariation
%fprintf(1, "Skewness:")
%skewness
fprintf(1, "Kurtosis:")
kurtosis
fprintf(1, "Percentile 10:")
percentile10
fprintf(1, "Percentile 25:")
percentile25
fprintf(1, "Percentile 50:")
percentile50
fprintf(1, "Percentile 75:")
percentile75
fprintf(1, "Percentile 90:")
percentile90
fprintf(1, "Cross-covariance for lag 1:")
lag1
fprintf(1, "Cross-covariance for lag 2:")
lag2
fprintf(1, "Cross-covariance for lag 3:")
lag3
fprintf(1, "Pearson Correlation Coefficient for lags 1:")
PearsonCorrelationCoefficient1
fprintf(1, "Pearson Correlation Coefficient for lags 2:")
PearsonCorrelationCoefficient2
fprintf(1, "Pearson Correlation Coefficient for lags 3:")
PearsonCorrelationCoefficient3