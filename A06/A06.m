clc, clear

lambdaHyperExp = [0.02, 0.2];
probHyperExp = 0.1;

N = 50000;

interArrivals = zeros(N, 1);

for k = 1:N
    randValue = rand();
    if randValue < probHyperExp
        interArrivals(k) = -log(rand()) / lambdaHyperExp(1,1);
    else
        interArrivals(k) = -log(rand()) / lambdaHyperExp(1,2);
    end
end

%figure
%plot(sort(interArrivals), (1:N)/N, ".b");


aUnif = 5;
bUnif = 10;

serviceTime = zeros(N, 1);

for i = 1:N
    serviceTime(i) = aUnif + rand() * (bUnif - aUnif);
end

%figure
%plot(sort(serviceTime), (1:N)/N, ".b");

arrivalTime = zeros(N, 1);


for i = 2:N
    arrivalTime(i) = arrivalTime(i - 1) + interArrivals(i - 1);
end


servedTime = zeros(N, 1);
servedTime(1) = arrivalTime(1);

for i = 2:N
    servedTime(i) = max(servedTime(i - 1) + serviceTime(i - 1), arrivalTime(i));
end

completionTime = servedTime + serviceTime;

responseTime = zeros(N,1);
responseTime(1) = serviceTime(1);

for i = 2:N
    responseTime(i) = completionTime(i) - arrivalTime(i);
end



dGamma = 1.96;
k = 200;
m = 250;

BusyTime = zeros(k,1);
Time = zeros(k,1);
Utilization = zeros(k,1);
Workload = zeros(k,1);
NumberOfJob = zeros(k,1);
Throughput = zeros(k,1);

for i = 1:k
    startCluster = (i - 1) * m + 1;
    endCluster = m * i;
        
    BusyTime(i) = sum(serviceTime(startCluster:endCluster));
    Time(i) = completionTime(endCluster) - arrivalTime(startCluster);
    Utilization(i) = BusyTime(i) / Time(i);
    
    Workload(i) = sum(responseTime(startCluster:endCluster));
    NumberOfJob(i) = Workload(i) / Time(i);
    
    Throughput(i) = m / Time(i);
end

xOverdueR = mean(responseTime);
s2R = std(responseTime)^2;
ResponseTime = [xOverdueR - dGamma * sqrt(s2R / N), xOverdueR + dGamma * sqrt(s2R / N)];

xOverdueN = mean(NumberOfJob);
s2N = sum((NumberOfJob - xOverdueN) .^ 2) / (k - 1);
NumberOfJob = [xOverdueN - dGamma * sqrt(s2N / k), xOverdueN + dGamma * sqrt(s2N / k)];

xOverdueX = mean(Throughput);
s2X = sum((Throughput - xOverdueX) .^ 2) / (k - 1);
Throughput = [xOverdueX - dGamma * sqrt(s2X / k), xOverdueX + dGamma * sqrt(s2X / k)];

xOverdueU = mean(Utilization);
s2U = sum((Utilization - xOverdueU) .^ 2) / (k - 1);
Utilization = [xOverdueU - dGamma * sqrt(s2U / k), xOverdueU + dGamma * sqrt(s2U / k)];

fprintf(1, "R - Lower bound and Upper bound:")
ResponseTime
fprintf(1, "NumberOfJob - Lower bound and Upper bound:")
NumberOfJob
fprintf(1, "X - Lower bound and Upper bound:")
Throughput
fprintf(1, "Utilization - Lower bound and Upper bound:")
Utilization