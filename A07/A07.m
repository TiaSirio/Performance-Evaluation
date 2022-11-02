clc, clear

lambdaSens = 0.1;
kSens = 3;

aCpu = 10;
bCpu = 20;

pWorkingSystem = [0.5, 0.2, 0.3];
cumSumWorkingSystem = cumsum(pWorkingSystem);

lambdaHeatPump = 0.05;
lambdaAirConditioning = 0.03;

state = 0;
time = 0;
dt = 0;
nextState = 0;

enterTheSensingState = 0;
timeSensing = 0;
timeCPU = 0;
timeAirConditioning = 0;
timeHeatPump = 0;

N = 50000;

for i = 1:N
    % CPU performing
    if state == 0
        dt = 0;
        for k = 1:kSens
            dt = dt - log(rand()) / lambdaSens;
        end
        nextState = 1;
        timeCPU = timeCPU + dt;
        enterTheSensingState = enterTheSensingState + 1;
    % Sensing
    elseif state == 1
        dt = aCpu + (bCpu - aCpu) * rand();
        r = rand();
        if r < cumSumWorkingSystem(1)
            nextState = 0;
        elseif r < cumSumWorkingSystem(2)
            nextState = 2;
        else
            nextState = 3;
        end
        timeSensing = timeSensing + dt;
    % Heat pump on
    elseif state == 2
        dt = - log(rand()) / lambdaHeatPump;
        timeHeatPump = timeHeatPump + dt;
        nextState = 0;
    % Air conditioning on
    elseif state == 3
        dt = - log(rand()) / lambdaAirConditioning;
        timeAirConditioning = timeAirConditioning + dt;
        nextState = 0;
    end
    state = nextState;
    time = time + dt;
end


pCPU = timeCPU / time;
pSensing = timeSensing / time;
pHeatPump = timeHeatPump / time;
pAirConditioning = timeAirConditioning / time;
X = enterTheSensingState / time;

probabilityCheck = pCPU + pSensing + pHeatPump + pAirConditioning;
if (round(probabilityCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end


fprintf(1, "Sensing probability:")
pCPU
fprintf(1, "Using CPU probability:")
pSensing
fprintf(1, "Turning Heat Pump probability:")
pHeatPump
fprintf(1, "Turning Air conditioning probability:")
pAirConditioning
fprintf(1, "Sensing frequency:")
X