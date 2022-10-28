clc, clear

a = 1;
b = 2;
c = 0.5;
d = 0.2;

Q = [-a - d, a, d;
    0, -b, b;
    c, 0, -c];

pi0 = [0, 0, 1];

Tmax = 4;

[t, pit] = ode45(@(t,x) Q' * x, [0 Tmax], pi0');

%{
j = 1;
for i = 0: 0.05:4
    t(j,1) = i;
    pit(j,:) = pi0 * expm(Q * i); %Qualcosa
    j = j + 1;
end
%}

Qp = [ones(3,1), Q(:, 2:3)];

u = [1, 0, 0];

pis = u * inv(Qp)

plot(t, pit, "-");
legend("s1", "s2", "s3");