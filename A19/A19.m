clc, clear;

lambda = [5;
         10];

D = [0.05, 0.1;
    0.06, 0.04];

%{
lambda = [0.1;
          10];

D = [2, 5;
     0.06, 0.04];
%}
Uck = D .* [lambda lambda];

Uk = sum(Uck);

Xc = lambda;

X = sum(Xc);

Rck = D ./ (1 - [Uk; Uk]);

Rk = sum(Xc ./ [X; X] .* Rck);

R = sum(Rk);

fprintf("Utilization\n");
fprintf("CRM: %f\n", Uk(1));
fprintf("FS: %f\n", Uk(2));
fprintf("\n");

fprintf("Residence time\n");
fprintf("CRM: %f\n", Rk(1));
fprintf("FS: %f\n", Rk(2));
fprintf("\n");

fprintf("System response time\n");
fprintf("%f\n", R);
fprintf("\n");