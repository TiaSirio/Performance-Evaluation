clc, clear all

filename = "apache1.log";

%log = readtable(filename, 'Format', '%s%s%s%s%s%s%s%s%s%s%s')
log = readtable(filename);

log.Properties.VariableNames = ["IP","string1","string2","timeStamp","value1","HTTP-Request","statusCode","value2","string3","browser","serviceTimeMilliseconds"];

table = log(:,[4,11]);
table.serviceTimeMilliseconds = milliseconds(table.serviceTimeMilliseconds);
table.timeStamp = strrep(table.timeStamp, '[', '');
table.timeStamp = replaceBetween(table.timeStamp,12,12,' ');
table.timeStampConverted = datetime(table.timeStamp,'InputFormat','dd/MMM/yyyy HH:mm:ss.SSS', 'Format', 'dd/MMM/yyyy HH:mm:ss.SSS');

table.day = day(table.timeStampConverted);
table.month = month(table.timeStampConverted);
table.year = year(table.timeStampConverted);
table.hour = hour(table.timeStampConverted);
table.minute = minute(table.timeStampConverted);
table.second = second(table.timeStampConverted)
%table.millisecond = millisecond(table.timeStampConverted);

%table = log(:,[4,11]);
%table.serviceTimeMilliseconds = milliseconds(log.Var11);

%Take the two important values needed and store it in a table
%table.Properties.VariableNames = ["timeStamps", "serviceTimeMilliseconds"];

%table