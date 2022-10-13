clc, clear

filename = "random.csv";

table = readtable(filename);

table.Properties.VariableNames = ["discrete", "continuous1", "continuous2"];

N = size(table, 1);

sizeCDF = 500;

aUnif = 5;
bUnif = 15;

C = cumsum(table.discrete);

%{
r = rand();
for k = 1:sizeCDF
    for i = 1:N
        if r < C(i)
            res(k) = i;
        end
    end
end
%}

for i = 1:sizeCDF
    res(i) = aUnif + floor(table.discrete(i) * (bUnif - aUnif + 1));
end

res