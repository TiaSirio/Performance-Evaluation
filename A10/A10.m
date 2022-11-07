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

pi0 = [1, 0, 0, 0];

Tmax = 500;

[t, pit] = ode45(@(t,x) Q' * x, [0 Tmax], pi0');

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



systemThroughput = [0, 0, 0, 0;
                    1, 0, 0, 0;
                    0, 0, 0, 0;
                    0, 0, 0, 0];

systemThroughputFinal = Q * systemThroughput';



GPUThroughput = [0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 1, 0, 0];

GPUThroughputFinal = Q * GPUThroughput';



IOThroughput = [0, 0, 0, 0;
                0, 0, 0, 0;
                0, 1, 0, 0;
                0, 0, 0, 0];

IOThroughputFinal = Q * IOThroughput';

%% Check

QCheck = [ones(4,1), Q(:, 2:4)];

u = [1, 0, 0, 0];

pis = u * inv(QCheck);

pCheck = sum(pis);

if (round(pCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end