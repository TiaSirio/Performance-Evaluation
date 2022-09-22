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

T = zeros;

for i = 1 : size(table)
    table.arrivalTimestamp(i) = T;
    T = T + table{i, 1};
end

Lambda = A / T; % Arrival rate

X = C / T; % Throughput

AOverdue = sum(table.interarrivals) / A; % Average interarrival time

