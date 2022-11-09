%% Exercise
clc, clear

energyIdle = 0.1;
energyCPU = 2;
energyIO = 0.5;
energyGPU = 10;

newJob = 1/10;
returnIdle = 1/50;
goingIO = 1/10;
returnCPUFromIO = 1/5;
goingGPU = 1/20;
returnCPUFromGPU = 1/2;

Q = [-newJob, newJob, 0, 0;
    returnIdle, -returnIdle - goingIO - goingGPU, goingIO, goingGPU;
    0, returnCPUFromIO, -returnCPUFromIO, 0;
    0, returnCPUFromGPU, 0, -returnCPUFromGPU];

systemThroughput = [0, 0, 0, 0;
                    1, 0, 0, 0;
                    0, 0, 0, 0;
                    0, 0, 0, 0];

pi0 = [1, 0, 0, 0];

Tmax = 500;

[t, pit] = ode45(@(t,x) Q' * x, [0 Tmax], pi0');

%{
j = 1;
for i = 0:500
    t(j,1) = i;
    pit(j,:) = pi0 * expm(Q * i);

    tr(j,1) = 0;

    for ii = 1:4
        for jj = 1:4
            if ii ~= jj
                tr(j,1) = tr(j,1) + pit(j,ii) * Q(ii,jj) * systemThroughput(ii, jj);
            end
        end
    end
end
%}

figure
plot(t, pit, "-");
legend("Idle", "CPU computation", "GPU computation", "I/O");
title("Probability of various states");



alphaUtilization = [0, 1, 1, 1];
powerUtilization = pit * alphaUtilization';

figure
plot(t, powerUtilization, "-");
legend("Power");
title("Utilization");

endValuesUtilization = [pit(end,:) * alphaUtilization', max(pit * alphaUtilization')];



alphaPowerConsumption = [energyIdle, energyCPU, energyIO, energyGPU];
averagePowerConsumption = pit * alphaPowerConsumption';

figure
plot(t, averagePowerConsumption, "-");
legend("Power");
title("Average power consumption");



QCheck = [ones(4,1), Q(:, 2:4)];

u = [1, 0, 0, 0];

pis = u * inv(QCheck);

systemThroughputFinal = ((Q .* systemThroughput)') * pis';



GPUThroughput = [0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 1, 0, 0];

GPUThroughputFinal = ((Q .* GPUThroughput)') * pis';



IOThroughput = [0, 0, 0, 0;
                0, 0, 0, 0;
                0, 1, 0, 0;
                0, 0, 0, 0];

IOThroughputFinal = ((Q .* IOThroughput)') * pis';

%% Check

pCheck = sum(pis);

if (round(pCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end