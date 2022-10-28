%% Exercise
clc, clear

available4G = 1/20;
establishAgain4G = 1/2;
availableWiFi = 1/3;
establishAgainWiFi = 1/8;
resetAllChannel = 1/100;

Q = [-available4G - availableWiFi - resetAllChannel, available4G, availableWiFi, resetAllChannel;
    establishAgain4G, -establishAgain4G - availableWiFi, 0, availableWiFi;
    establishAgainWiFi, 0, -establishAgainWiFi - available4G, available4G;
    0, establishAgainWiFi, establishAgain4G, -establishAgainWiFi - establishAgain4G];

pi0 = [1, 0, 0, 0];

Tmax = 300;

[t, pit] = ode45(@(t,x) Q' * x, [0 Tmax], pi0');

plot(t, pit, "-");
legend("4G - ON, WiFi ON", "4G - OFF, WiFi ON", "4G - ON, WiFi OFF", "4G - OFF, WiFi OFF");
title("Probability of various states");

%% Check

QCheck = [ones(4,1), Q(:, 2:4)];

u = [1, 0, 0, 0];

pis = u * inv(QCheck);

pCheck = sum(pis);

if (round(pCheck,3) ~= round(1,3))
    error("Probability not corrispondent!")
end