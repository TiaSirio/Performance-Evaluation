clc, clear

fileOutput = "finalResult.txt";

if exist(fileOutput, 'file') == 2
  delete(fileOutput);
end

filename = "Log1.csv";
filename2 = "Log2.csv";
filename3 = "Log3.csv";
filename4 = "Log4.csv";

%log = readtable(filename);
%log = readtable(filename2);
%log = readtable(filename3);
log = readtable(filename4);

log.Properties.VariableNames = "interarrivals";

table = log(:,1);

A = size(table,1); % Arrivals
C = A; % Completions

serviceTime = seconds(1.2);

temp = zeros + table{1, 1};
table.arrivalTimestamp(1) = seconds(zeros);

for i = 2 : size(table)
    table.arrivalTimestamp(i) = seconds(temp);
    temp = temp + table{i, 1};
end

%table.arrivalTimestamp(size(table) + 1) = seconds(temp);

AOverdue = seconds(sum(table.interarrivals) / A); % Average interarrival time

Lambda = 1 / seconds(AOverdue); % Arrival rate

table.servedTime(1) = seconds(zeros);

for i = 2 : size(table)
    table.servedTime(i) = max(table.servedTime(i - 1) + serviceTime, table.arrivalTimestamp(i));
end

table.completions = table.servedTime + serviceTime;

Ri = seconds(table.completions - table.arrivalTimestamp);

R = seconds(sum(Ri)) / C; % Average response time

standardDeviation = std(table.interarrivals); % Standard deviation

%XY = [Ri(1:end - 1), Ri(2:end)];
XY = [table.interarrivals(1:end - 1), table.interarrivals(2:end)];
plot(XY(:,1), XY(:,2), ".b")

%Error handling
AOverdueCheck = seconds(1 / Lambda);
if (round(seconds(AOverdueCheck),10) ~= round(seconds(AOverdue),10))
    error("Average inter-arrival time not corrispondent!")
end



fprintf(1, "Arrival Rate:")
Lambda
fprintf(1, "Average inter-arrival time:")
AOverdue
fprintf(1, "Standard deviation:")
standardDeviation
fprintf(1, "Average response time:")
R