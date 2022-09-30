clc, clear all

filename = "Data1.txt";
filename2 = "Data2.txt";
filename3 = "Data3.txt";
filename4 = "Data4.txt";

log = readtable(filename);
log2 = readtable(filename2);
log3 = readtable(filename3);
log4 = readtable(filename4);

table = log(:,1);

table.Properties.VariableNames = "data";

tableSorted = sortrows(table(:,1));

N = size(table, 1);

%plot(tableSorted.Data1, [1:N]/N, "+");

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

thirdStandardizedMoment = sum(((table.data - EX) / sigm) .^3) / N;

fourthStandardizedMoment = sum(((table.data - EX) / sigm) .^4) / N;

std = std(table.data);

skewness = skewness(table.data);

kurtosis = kurtosis(table.data);

h10 = (N - 1) * 10 / 100 + 1;
h25 = (N - 1) * 25 / 100 + 1;
h50 = (N - 1) * 50 / 100 + 1;
h75 = (N - 1) * 75 / 100 + 1;
h90 = (N - 1) * 90 / 100 + 1;

%usare il normal array e non il sorted (penso (riguardare registrazione (o forse il contrario)))

percentile10 = tableSorted.data(floor(h10),1) + (h10 - floor(h10)) * (tableSorted.data(floor(h10) + 1, 1) - tableSorted.data(floor(h10),1));
percentile25 = tableSorted.data(floor(h25),1) + (h25 - floor(h25)) * (tableSorted.data(floor(h25) + 1, 1) - tableSorted.data(floor(h25),1));
percentile50 = tableSorted.data(floor(h50),1) + (h50 - floor(h50)) * (tableSorted.data(floor(h50) + 1, 1) - tableSorted.data(floor(h50),1));
percentile75 = tableSorted.data(floor(h75),1) + (h75 - floor(h75)) * (tableSorted.data(floor(h75) + 1, 1) - tableSorted.data(floor(h75),1));
percentile90 = tableSorted.data(floor(h90),1) + (h90 - floor(h90)) * (tableSorted.data(floor(h90) + 1, 1) - tableSorted.data(floor(h90),1));

%USE THE REAL ONE

lag1 = sum((table.data(1:end - 1, :) - EX) .* (table.data(2:end, :) - EX)) / (N - 1);
lag2 = sum((table.data(1:end - 2, :) - EX) .* (table.data(3:end, :) - EX)) / (N - 1);
lag3 = sum((table.data(1:end - 3, :) - EX) .* (table.data(4:end, :) - EX)) / (N - 1);

%not sure
PearsonCorrelationCoefficient1 = sum((table.data(1:end - 1, :) - EX) .* (table.data(2:end, :) - EX)) / (N - 1) ./ (sigm .^ 2);
PearsonCorrelationCoefficient2 = sum((table.data(1:end - 2, :) - EX) .* (table.data(3:end, :) - EX)) / (N - 1) ./ (sigm .^ 2);
PearsonCorrelationCoefficient3 = sum((table.data(1:end - 3, :) - EX) .* (table.data(4:end, :) - EX)) / (N - 1) ./ (sigm .^ 2);

%y = [lag1, lag2, lag3];
%plot([1:3], y, ".");