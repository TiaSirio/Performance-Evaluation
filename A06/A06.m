lambdaHyperExp = [0.02, 0.2];
probHyperExp = 0.1;

N = 50000;
k = 200;
m = 250;

arrivals = zeros(N, 1);

for k = 1:N
    randValue = rand();
    if randValue < probHyperExp(1,1)
        arrivals(k) = -log(rand()) / lambdaHyperExp(1,1);
    else
        arrivals(k) = -log(rand()) / lambdaHyperExp(1,2);
    end
end

%figure
%plot(sort(arrivals), (1:N)/N, ".b");


aUnif = 5;
bUnif = 10;

services = zeros(N, 1);

for i = 1:N
    services(i) = aUnif + rand() * (bUnif - aUnif);
end

%figure
%plot(sort(services), (1:N)/N, ".b");

dGamma = 1.96;

%averageService = sum(services) / N;

%xMean = (1 / N) * sum(services);

%sSquared = (1 / (N - 1)) * sum((services - xMean).^2)