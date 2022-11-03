clc, clear

N = 16;
N0 = 8;

%b = 5*10^-4;
%m = 0.2;
%b0 = 10^-2;

% Non ho capito m
%m = 0.2;
m = 1/100;
b = 1/200;


pn = zeros(1, N + 1);
pd = zeros(1, N + 1);

pn(1,1) = 0;
pd(1,1) = 0;

for i = 1:N
	if i < 8
		lim1 = b;
    else
        lim1 = b * ((N - i) / (N - N0));
		%lim1 = b * (N - i + 1) * (i - 1);
	end
	mi = i * m;
	pn(1, i + 1) = pn(1,i) + log(lim1);
	pd(1, i + 1) = pd(1,i) + log(mi);
end

p = exp(pn - pd);
p = p / sum(p);

plot(0:N, p);
