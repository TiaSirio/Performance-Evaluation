clc, clear

lambdaHyperExp = [0.02, 0.2];
probHyperExp = 0.1;

N = 50000;

interArrivals = zeros(N, 1);

for k = 1:N
    randValue = rand();
    if randValue < probHyperExp(1,1)
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

arrivalTime = zeros(N + 1, 1);

for i = 2:N + 1
    arrivalTime(i) = arrivalTime(i - 1) + interArrivals(i - 1);
end

servedTime = zeros(N, 1);
servedTime(1) = arrivalTime(1);

for i = 2 : size(table)
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

%averageService = sum(services) / N;

%xMean = (1 / N) * sum(services);

%sSquared = (1 / (N - 1)) * sum((services - xMean).^2)