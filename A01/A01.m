clc, clear all

filename = "apache1.log";
filename2 = "apache2.log";

%log = readtable(filename, 'Format', '%s%s%s%s%s%s%s%s%s%s%s')
log = readtable(filename);
%log2 = readtable(filename2);

%finalLog = vertcat(log, log2);

log.Properties.VariableNames = ["IP","string1","string2","timeStamp","value1","HTTP-Request","statusCode","value2","string3","browser","serviceTimeMilliseconds"];

table = log(:,[4,11]);
table.serviceTimeMilliseconds = milliseconds(table.serviceTimeMilliseconds);

table.timeStamp = strrep(table.timeStamp, '[', '');
table.timeStamp = replaceBetween(table.timeStamp,12,12,' ');
table.timeStampConverted = datetime(table.timeStamp,'InputFormat','dd/MMM/yyyy HH:mm:ss.SSS', 'Format', 'dd/MMM/yyyy HH:mm:ss.SSS');

A = size(table,1); %Arrival
C = A; %Completions

table.servedTime = table.timeStampConverted + table.serviceTimeMilliseconds;

for i = 2:size(table)
    table.servedTimeFixed(i) = max(table.servedTime(i - 1) + table.serviceTimeMilliseconds(i - 1), table.timeStampConverted(i));
end

firstTimestamp = table.timeStampConverted(1);
lastTimestamp = table.servedTimeFixed(A) + table.serviceTimeMilliseconds(A);

deltaTime = seconds(lastTimestamp - firstTimestamp);

B = sum(table.serviceTimeMilliseconds); % Busy time

lambda = A / deltaTime % Arrival rate

X = C / deltaTime % Throughput
% Since the system is stable -> lambda = X

U = B / deltaTime % Utilization

S = B / C; % Average service time

Ri = table.serviceTimeMilliseconds - table.timeStampConverted