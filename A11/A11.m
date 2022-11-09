clc, clear

N = 16;
N0 = 8;

%b = 5*10^-4;
%m = 0.2;
%b0 = 10^-2;

% Non ho capito m, penso mu
m = 100;
b = 200;

pn = zeros(1, N + 1);
pd = zeros(1, N + 1);

pn(1,1) = 0;
pd(1,1) = 0;

for i = 1:N
    r = rand();
    valueOfProbability = min(1, (i - N0)/(N - N0));
    if (i > N0) && valueOfProbability < r
        if i < N0
		    lim1 = b;
        else
            lim1 = b * ((N - i + 1) / (N - N0));
        end
	    mi = m;
	    pn(1, i + 1) = pn(1, i) + log(lim1);
	    pd(1, i + 1) = pd(1, i) + log(mi);
    end
end

p = exp(pn - pd);
p = p / sum(p);

plot(0:N, p);
