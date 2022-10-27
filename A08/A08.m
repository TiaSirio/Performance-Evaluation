clc, clear

lambdaPrepareJob = 0.05;
lambdaFullSpeed = 1;
lambdaGarbage = 0.3;

lambdaGarbageStart = 0.1;
lambdaGarbageEnd = 0.4;

numberOfJobStarted = 0;

tPrepareJob = 0;
tRunningFullSpeed = 0;
tGarbageCollector = 0;

state = 0;
time = 0;
dt = 0;
nextState = 0;

Tmax = 100000;

while time < Tmax
    % Job not prepared GC on
	if state == 0
		tPreparingJob = -log(rand()) / lambdaPrepareJob;
        tShuttingDownGarbage = -log(rand()) / lambdaGarbageEnd;
        if(tPreparingJob < tShuttingDownGarbage)
			nextState = 2;
            dt = tPreparingJob;
            tPrepareJob = tPrepareJob + dt;
            numberOfJobStarted = numberOfJobStarted + 1;
		else
			nextState = 1;
            dt = tShuttingDownGarbage;
        end
    % Job not prepared GC off
    elseif state == 1
		tPreparingJob = -log(rand()) / lambdaPrepareJob;
        tTurningOnGarbage = -log(rand()) / lambdaGarbageStart;
		if(tPreparingJob < tTurningOnGarbage)
			nextState = 3;
            dt = tPreparingJob;
            tPrepareJob = tPrepareJob + dt;
            numberOfJobStarted = numberOfJobStarted + 1;
		else
			nextState = 0;
            dt = tTurningOnGarbage;
		end
    % Job starting GC on
    elseif state == 2
		tEndingJobWhenGCOn = -log(rand()) / lambdaGarbage;
        tShuttingDownGarbage = -log(rand()) / lambdaGarbageEnd;
        if(tEndingJobWhenGCOn < tShuttingDownGarbage)
			nextState = 0;
            dt = tEndingJobWhenGCOn;
            tRunningFullSpeed = tRunningFullSpeed + dt;
            numberOfJobStarted = numberOfJobStarted + 1;
		else
			nextState = 3;
            dt = tShuttingDownGarbage;
        end
    % Job starting GC off
    else
        tEndingJobWhenGCOff = -log(rand()) / lambdaFullSpeed;
        tTurningOnGarbage = -log(rand()) / lambdaGarbageStart;
        if(tEndingJobWhenGCOff < tTurningOnGarbage)
			nextState = 1;
            dt = tEndingJobWhenGCOff;
            tGarbageCollector = tGarbageCollector + dt;
            numberOfJobStarted = numberOfJobStarted + 1;
		else
			nextState = 2;
            dt = tTurningOnGarbage;
        end
	end

	state = nextState;
	time = time + dt;
	
	%trace(end + 1, :) = [t, s];
end

pPrepareNewJob = tPrepareJob / time
pFullSpeed = tRunningFullSpeed / time
pGarbageCollector = tGarbageCollector / time
X = numberOfJobStarted / time
