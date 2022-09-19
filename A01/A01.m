clear all

log = readtable("apache1.log");
table = log(:,4);
table.millisecondsAfter = milliseconds(log.Var11);

%Take the two important values needed and store it in a table
table.Properties.VariableNames = ["timeStamps", "millisecondsAfter"]

table