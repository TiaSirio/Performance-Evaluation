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

table.servedTime(1) = table.timeStampConverted(1) + table.serviceTimeMilliseconds(1);

for i = 2 : size(table)
    table.servedTime(i) = max(table.servedTime(i - 1), table.timeStampConverted(i)) + table.serviceTimeMilliseconds(i);
end

for i = 1 : size(table) - 1
    table.Ai(i) = seconds(table.timeStampConverted(i + 1) - table.timeStampConverted(i));
end

Ai = table.Ai; % Interarrivals times

AOverdue = sum(Ai) / A; % Average interarrivals times

%table

firstTimestamp = table.timeStampConverted(1);
lastTimestamp = table.servedTime(A);

T = seconds(lastTimestamp - firstTimestamp);

B = sum(table.serviceTimeMilliseconds); % Busy time

Lambda = A / T; % Arrival rate

X = C / T; % Throughput
% Since the system is stable -> lambda = X

U = B / T; % Utilization

S = B / C; % Average service time

Ri = table.serviceTimeMilliseconds; % Response times = Service times

W = sum(Ri); % Workload

R = W / C; % Average response time

N = W / T; % Average number of jobs

probabilityResponseTimeTau1 = sum(Ri > seconds(1)) / C; % Probability of having resposne time less then 1

probabilityResponseTimeTau5 = sum(Ri > seconds(5)) / C; % Probability of having resposne time less then 5

probabilityResponseTimeTau10 = sum(Ri > seconds(10)) / C; % Probability of having resposne time less then 10

%comb = [table.timeStampConverted, ones(A, 1); table.servedTime, -ones(C, 1)]


probabilityOfJob0 = 0;
probabilityOfJob1 = 0;
probabilityOfJob2 = 0;
probabilityOfJob3 = 0;

fprintf(1, "Arrival Rate:")
Lambda
fprintf(1, "Throughput:")
X
fprintf(1, "Average inter-arrival time:")
AOverdue
fprintf(1, "Busy time:")
B
fprintf(1, "Utilization:")
U
fprintf(1, "W:")
W
fprintf(1, "Average Service Time:")
S
fprintf(1, "Average Number of Jobs:")
N
fprintf(1, "Average Response Time:")
R
fprintf(1, "Pr(R > 1):")
probabilityResponseTimeTau1
fprintf(1, "Pr(R > 5):")
probabilityResponseTimeTau5
fprintf(1, "Pr(R > 10):")
probabilityResponseTimeTau10
fprintf(1, "Pr(N = 0):")
probabilityOfJob0
fprintf(1, "Pr(N = 1):")
probabilityOfJob1
fprintf(1, "Pr(N = 2):")
probabilityOfJob2
fprintf(1, "Pr(N = 2):")
probabilityOfJob3

%fprintf(1, "Arrival Rate: %g, Throughput %g\n", Lambda, X);
%fprintf(1, "Average inter-arrival time: %g\n", AOverdue);
%fprintf(1, "Busy time: %s\n", B);
%fprintf(1, "Utilization: %d\n", U);
%fprintf(1, "W: %g\n", W);
%fprintf(1, "Average Service Time: %g\n", S);
%fprintf(1, "Average Number of Jobs: %g\n", N);
%fprintf(1, "Average Response Time: %g\n", R);
%fprintf(1, "Pr(R > 1): %g\n", probabilityResponseTimeTau1);
%fprintf(1, "Pr(R > 5): %g\n", probabilityResponseTimeTau5);
%fprintf(1, "Pr(R > 10): %g\n", probabilityResponseTimeTau10);