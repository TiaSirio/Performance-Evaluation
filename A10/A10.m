%% Exercise
clc, clear

energyIdle = 0.1;
energyCPU = 2;
energyIO = 0.5;
energyGPU = 10;

energyAlpha = [energyIdle, energyCPU, energyIO, energyGPU];

newJob = 1/20;
returnIdle = 1/50;
goingIO = 1/10;
returnCPUFromIO = 1/5;
goingGPU = 1/20;
returnCPUFromGPU = 1/2;

Q = [-newJob, newJob, 0, 0;
    newJob, -newJob - goingIO - goingGPU, goingIO, goingGPU;
    0, returnCPUFromIO, -returnCPUFromIO, 0;
    0, returnCPUFromGPU, 0, -returnCPUFromGPU];

pi0 = [1, 0, 0, 0];

Tmax = 500;

[t, pit] = ode45(@(t,x) Q' * x, [0 Tmax], pi0');

plot(t, pit, "-");
legend("Idle", "CPU computation", "GPU computation", "I/O");
title("Probability of various states");



QCheck = [ones(4,1), Q(:, 2:4)];

u = [1, 0, 0, 0];

pis = u * inv(QCheck);


%% Check
pCheck = sum(pis);

if (round(pCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end