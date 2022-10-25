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



R = zeros(k,1);

B = zeros(k,1);
T = zeros(k,1);
U = zeros(k,1);
W = zeros(k,1);
Nj = zeros(k,1);
X = zeros(k,1);

for i = 1:k
    start = (i - 1) * m + 1;
    stop = m * i;
    
    R(i) = mean(responseTime(start:stop));
    
    B(i) = sum(serviceTime(start:stop));
    T(i) = completionTime(stop) - arrivalTime(start);
    U(i) = B(i) / T(i);
    
    W(i) = sum(responseTime(start:stop));
    Nj(i) = W(i) / T(i);
    
    X(i) = m / T(i);
end

xOverdueU = mean(U);
s2U = sum((U - xOverdueU) .^ 2) / (k - 1);
U = [xU - dGamma * sqrt(s2U / k), xOverdueU + dGamma * sqrt(s2U / k)]

%{
Metodo 1 (?)
xR = mean(responseTime)
s2R = std(responseTime)^2;
R = [xR - d*sqrt(s2R / N), xR + d*sqrt(s2R / N)]
%}

xOverdueR = mean(R);
s2R = sum((R - xOverdueR) .^ 2) / (k - 1);
R = [xR - dGamma * sqrt(s2R / k), xOverdueR + dGamma * sqrt(s2R / k)]

xOverdueN = mean(Nj);
s2N = sum((Nj - xOverdueN) .^ 2) / (k - 1);
Nj = [xN - dGamma * sqrt(s2N / k), xOverdueN + dGamma * sqrt(s2N / k)]

xOverdueX = mean(X);
s2X = sum((X - xOverdueX) .^ 2) / (k - 1);
X = [xX - dGamma * sqrt(s2X / k), xOverdueX + dGamma * sqrt(s2X / k)]
