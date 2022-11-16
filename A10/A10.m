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

GPUThroughput = [0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 0, 0, 0;
                 0, 1, 0, 0];

IOThroughput = [0, 0, 0, 0;
                0, 0, 0, 0;
                0, 1, 0, 0;
                0, 0, 0, 0];

pi0 = [1, 0, 0, 0];

Tmax = 500;

j = 1;
for i = 1:Tmax
    t(j,1) = i;
    pit(j,:) = pi0 * expm(Q * i);

    troughputSystem(j,1) = 0;

    for ii = 1:4
        for jj = 1:4
            if ii ~= jj
                troughputSystem(j,1) = troughputSystem(j,1) + pit(j,ii) * Q(ii,jj) * systemThroughput(ii, jj);
            end
        end
    end

    troughputGPU(j,1) = 0;
    
    for ii = 1:4
        for jj = 1:4
            if ii ~= jj
                troughputGPU(j,1) = troughputGPU(j,1) + pit(j,ii) * Q(ii,jj) * GPUThroughput(ii, jj);
            end
        end
    end

    troughputIO(j,1) = 0;

    for ii = 1:4
        for jj = 1:4
            if ii ~= jj
                troughputIO(j,1) = troughputIO(j,1) + pit(j,ii) * Q(ii,jj) * IOThroughput(ii, jj);
            end
        end
    end
    j = j + 1;
end



QCheck = [ones(4,1), Q(:, 2:4)];

u = [1, 0, 0, 0];

pis = u * inv(QCheck);



figure
plot(t, pit, "-");
legend("Idle", "CPU computation", "I/O", "GPU computation");
title("Probability of various states");

figure
plot(t, troughputSystem, "-", t, troughputGPU, "-", t, troughputIO, "-");
legend("System throughput", "GPU throughput", "IO throughput");
title("Transition rewards");



alphaUtilization = [0, 1, 1, 1];
powerUtilizationTransient = pit * alphaUtilization';
powerUtilizationSteady = max(pit * alphaUtilization');

alphaPowerConsumption = [energyIdle, energyCPU, energyIO, energyGPU];
averagePowerConsumptionTransient = pit * alphaPowerConsumption';
averagePowerConsumptionSteady = max(pit * alphaPowerConsumption');

figure
plot(t, powerUtilizationTransient, "-", t, averagePowerConsumptionTransient, "-");
legend("Utilization", "Average power consumption");
title("State rewards");



systemThroughputSteady = sum((Q .* systemThroughput)') * pis';

GPUThroughputSteady = sum((Q .* GPUThroughput)') * pis';

IOThroughputSteady = sum((Q .* IOThroughput)') * pis';

%% Check

pCheck = sum(pis);

if (round(pCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end

if (round(powerUtilizationSteady,3) ~= round(powerUtilizationTransient(end,1),3))
    error("Probability not corrispondent!")
end

if (round(averagePowerConsumptionSteady,3) ~= round(averagePowerConsumptionTransient(end,1),3))
    error("Probability not corrispondent!")
end

if (round(systemThroughputSteady,3) ~= round(troughputSystem(end,1),3))
    error("Probability not corrispondent!")
end

if (round(GPUThroughputSteady,3) ~= round(troughputGPU(end,1),3))
    error("Probability not corrispondent!")
end

if (round(IOThroughputSteady,3) ~= round(troughputIO(end,1),3))
    error("Probability not corrispondent!")
end

fprintf(1, "Power utilization:")
powerUtilizationSteady
fprintf(1, "Average Power consumption:")
averagePowerConsumptionSteady
fprintf(1, "System throughput:")
systemThroughputSteady
fprintf(1, "GPU throughput:")
GPUThroughputSteady
fprintf(1, "IO throughput:")
IOThroughputSteady