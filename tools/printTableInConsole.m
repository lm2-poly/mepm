function printTableInConsole(data)

%**************************************************************************
% printTableInConsole.m
% Last updated : 2020-06-13
%**************************************************************************
% This function 
% 
% Author: Jean-François Chauvette
% Date: June 13, 2020
%**************************************************************************

prefix = [inputname(1) '_'];
VarNames = cellstr(strcat(prefix,string(1:size(data,2)))); % Variable names for table console print
values = num2cell(data);   % Values to be output in the console
T = table(values{:}, 'VariableNames',VarNames); % Constructing the table
disp(T);  % Displaying the table

end