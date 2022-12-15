clc, clear;

lambdaE = 5;
lambdaP = 10;

D1E = 0.05;
D1P = 0.06;
D2E = 0.1;
D2P = 0.04;

U1E = lambdaE * D1E;
U1P = lambdaE * D1P;
U2E = lambdaP * D2E;
U2P = lambdaP * D2P;

U1 = U1E + U1P;
U2 = U2E + U2P;

R1E = D1E / (1 - (U1));
R1P = D1P / (1 - (U1));
R2E = D2E / (1 - (U2));
R2P = D2P / (1 - (U2));

R1 = R1E + R1P;
R2 = R2E + R2P;

RTot = R1 + R2;