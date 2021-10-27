%**************************************************************************
% validation_infos script
% Last updated : 2020-06-13
%**************************************************************************
% This script contains a switch case structure to rapidly initialize
% variables that are usually input by the user. Each case number
% corresponds to the excel sheet number of the material database
% spreadsheet "EPON828_formulations.xls".
%
% Authors: Jean-François Chauvette
% Date: October 10, 2020
%**************************************************************************
% Literature data for comparison
P_lit = 0;
Q_lit = 0;

SR_lit = 0;
eta_lit = 0;

switch(str2double(sheetNum))
    case 1 % Abradable 0GM:12FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 2 % Abradable 5GM:10FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 3 % Abradable 10GM:8FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 4 % EPON 828 0GM:14FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 5 % EPON 828 5GM:12FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 6 % EPON 828 10GM:10FS
        P_lit = 0;
        Q_lit = 0;

        SR_lit = 0;
        eta_lit = 0;
    case 7 % Organic ink 60/40 JFC, made with multinozzle geometry
        P_lit = 0;
        Q_lit = 0;

        SR_lit = [1906.711052 3844.953236 5838.286195 7667.693335 9636.776769];
        eta_lit = [11.72851185 7.106843087 6.351797891 5.296440214 4.740399485];
end
