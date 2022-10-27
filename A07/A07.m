clc, clear

lambdaSens = 0.1;
kSens = 3;

aCpu = 10;
bCpu = 20;

pWorkingSystem = [0.5, 0.3, 0.2];
cumSumWorkingSystem = cumsum(pWorkingSystem);

lambdaHeatPump = 0.03;
lambdaAirConditioning = 0.05;

state = 1;
time = 0;
dt = 0;
nextState = 0;

N = 50000;
traceStateMachine = zeros(N, 3);
%trace = zeros(N, 3);
enterTheSensingState = 0;
timeSensing = 0;
timeCPU = 0;
timeAirConditioning = 0;
timeHeatPump = 0;


for i = 1:N
    % CPU performing
    if state == 0
        dt = 0;
        for k = 1:kSens
            dt = dt - log(rand()) / lambdaSens;
        end
        nextState = 1;
        timeCPU = timeCPU + dt;
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
        enterTheSensingState = enterTheSensingState + 1;
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

    %trace(i,:) = [time, time + dt, state];
    state = nextState;
    time = time + dt;
end


pCPU = timeCPU / time
pSensing = timeSensing / time
pHeatPump = timeHeatPump / time
pAirConditioning = timeAirConditioning / time
X = enterTheSensingState / time


%{
%% INTRO

% sens variables initialization
lambda_sens = 0.1;
K_sens = 3;

% cpu variables initialization
a_cpu = 10;
b_cpu = 20;
p_cpu = [0.5, 0.3, 0.2];
C_cpu = cumsum(p_cpu);
state_poss_cpu = size(C_cpu, 2);

% hp variables initialization
lambda_hp = 0.03;

% ac variables initialization
lambda_ac = 0.05;

% FSM variables initialization
s = 1;
t = 0;

% Other (possibly?) useful variables initialization
N = 50000;
trace = zeros(N, 3);


%% DATA GENERATION

for i = 1:N
    
    if s == 0        % CPU performing
        dt = a_cpu + (b_cpu-a_cpu) * rand();
        r = rand();
        for ns = 1:state_poss_cpu
            if r < C_cpu(ns)
                break
            end
        end
    
    elseif s == 1    % Sensing
       dt = 0;
        for k = 1:K_sens
            dt = dt - log(rand())/lambda_sens;
        end
        ns = 0;
    
    elseif s == 2    % Air conditioning on
        dt = - log (rand()) / lambda_ac;
        ns = 1;

    elseif s == 3    % Heat pump on
        dt = - log (rand()) / lambda_hp;
        ns = 1;
        
    end
    trace(i,:) = [t, t + dt, s];
    s = ns;
    t = t + dt;
end


%% Probabilities of job in a state

sens_times = trace(trace(:,3)==1, 1:2);
sens_prob = sum(sens_times(:,2)-sens_times(:,1)) / t;

cpu_times = trace(trace(:,3)==0, 1:2);
cpu_prob = sum(cpu_times(:,2)-cpu_times(:,1)) / t;

hp_times = trace(trace(:,3)==3, 1:2);
hp_prob = sum(hp_times(:,2)-hp_times(:,1)) / t;

ac_times = trace(trace(:,3)==2, 1:2);
ac_prob = sum(ac_times(:,2)-ac_times(:,1)) / t;

%% Frequency of the system

sens_freq = size(sens_times,1) / t;

%% PRINTS

fprintf("%f\n", sens_prob);
fprintf("%f\n", cpu_prob);
fprintf("%f\n", hp_prob);
fprintf("%f\n", ac_prob);
fprintf("%f\n", sens_freq);
%}