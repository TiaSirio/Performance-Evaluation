clc, clear all

filename = "Log1.csv";
filename2 = "Log2.csv";
filename3 = "Log3.csv";
filename4 = "Log4.csv";

log = readtable(filename);

log.Properties.VariableNames = "interarrivals";

table = log(:,1);

A = size(table,1); % Arrivals
C = A; % Completions

serviceTime = seconds(1.2);

T = zeros;

for i = 1 : size(table)
    table.arrivalTimestamp(i) = seconds(T);
    T = T + table{i, 1};
end

%Lambda2 = A / T;

AOverdue = seconds(sum(table.interarrivals) / A); % Average interarrival time

Lambda = 1 / seconds(AOverdue); % Arrival rate

table.servedTime(1) = seconds(zeros);

for i = 2 : size(table)
    table.servedTime(i) = max(table.servedTime(i - 1) + serviceTime, table.arrivalTimestamp(i));
end

table.completions = table.servedTime + serviceTime;

Ri = seconds(table.completions - table.arrivalTimestamp);

R = seconds(sum(Ri)) / C; % Average response time

standardDeviation = std(table.interarrivals) % Standard deviation



fprintf(1, "Average inter-arrival time:")
AOverdue
fprintf(1, "Arrival Rate:")
Lambda
fprintf(1, "Standard deviation:")
standardDeviation
fprintf(1, "Average response time:")
R