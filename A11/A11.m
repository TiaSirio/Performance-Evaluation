clc, clear

N = 16;
N0 = 8;

m = 100;
b = 200;

pn = zeros(1, N + 1);
pd = zeros(1, N + 1);

pn(1,1) = 0;
pd(1,1) = 0;

for i = 1:N
    if i < N0
	    lim1 = b;
    else
        lim1 = b * ((N - i + 1) / (N - N0));
    end
	    mi = m;
	    pn(1, i + 1) = pn(1, i) + log(lim1);
	    pd(1, i + 1) = pd(1, i) + log(mi);
end

p = exp(pn - pd);
p = p / sum(p);

plot(0:N, p, "+");
title("Buffer length distribution")
