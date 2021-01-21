%**************************************************************************
% main script
% Last updated : 2020-06-15
%**************************************************************************
% Description : General script that talks to other scripts, queries the
% database and interacts with the user. Also provides user feedback.
%
% Instructions:
%       This script must be used with the materialsDB.xls database.
%       Follow the instructions in the Matlab console.
%
% Authors: David Brzeski, Jean-François Chauvette
% Date: 2020-05-29
%**************************************************************************

clc;
clear all;
close all;

% Prints the current equations version
eqLibrary = 'Velocity-driven';
fprintf('Using %s library\n',eqLibrary);

% Imports
addpath(eqLibrary);
addpath('tools');

% Initializing variables
debug_mode = 1; % To print in the console all the intermediate values for calculation

% Opening the material database file
[file,path] = uigetfile('*.xls','Select the material database file to open');
if isequal(file,0) % File was not opened
    disp('User selected Cancel');
else % File was opened
    disp(['User selected ', fullfile(path,file)]);
    matFile = [path file];
    
    % List of all the materials included in the database (sheets in the
    % excel file)
    sheets = xl_xlsfinfo(matFile);
    fprintf('Available materials : \n')
    disp(sheets())
    
    % Retrieve the user specified material's infos
    choices = cellfun(@num2str,num2cell(1:size(sheets,1)),'un',0);
    sheetNum = validUserInput('Choose a material number : ', 0, choices{:});
    material = sheets{str2double(sheetNum),2};
    [rho, w, f, n, K, eta_inf, eta_0, tau_0, lambda, a] = readMaterial(matFile, material);
    
    fprintf('User selected %s\n', material);
    
    % Ask if prediction is for multinozzle
    multinozzle = validUserInput('Is this prediction for the multinozzle printhead (y/n)? ', 0, 'y','n');
    
    % Script call for testing purposes (auto-completion of alpha, D, L,
    % P_amb and v values).
    validation_infos;
  
    P = zeros(size(v,2),1);             % To plot the pressures
    eta = zeros(size(v,2),size(D,2));   % To plot the viscosity
    SR = zeros(size(v,2),size(D,2));    % To plot the shear rate
    Q = zeros(size(v,2),size(D,2));     % To re-calculate the true velocities
    v_all = zeros(size(v,2),size(D,2)); % To bar plot the velocities comparison
    Q_all = zeros(size(v,2),size(D,2));
    Q_theo = zeros(size(v,2),size(D,2)); % To bar plot the velocities comparison of theoretical Q with the big formula
    Errv_real = zeros(size(v,2),size(D,2)); % To bar plot the velocities comparison
    dRi = zeros(size(v,2),size(D,2));
    dP = zeros(size(v,2),1);
    deta = zeros(size(v,2),size(D,2));
    dSR= zeros(size(v,2),size(D,2));
    
    % Compute overall P for desired nozzle exit speed and retrieve viscosity/shear rate data
    % for each P/v
    for i=1:1:size(v,2)
        [newP,newEta,newSR,newQ,newdEta,newdP,newdRi,newdSR] = ...
            generateP(rho, v(i), D_avg, L, n, K, eta_0, eta_inf, tau_0, lambda, a, P_amb, debug_mode);
        if isnan(newP)
            error('Pressure could not be computed due to invalid Reynolds number');
        else
            P(i) = newP;
            eta(i,:) = newEta;
            SR(i,:) = newSR;
            Q(i,:) = newQ;
            dP(i) = newdP;
            dRi(i,:) = newdRi;
            deta(i,:) = newdEta;
            dSR(i,:) = newdSR;
        end
    end
    
    % Compute true velocity and flow for nozzle true applied pressure
    % for each P/v combination
    for i=1:1:size(v,2)
        [v_real, Q_real, dv_real,q_long] = generateVreal(P(i), dP(i,:),...
            Q(i,:), rho, v(i),D, L, n, K, eta_0, eta_inf, tau_0, lambda,...
            a, P_amb, debug_mode);
        v_all(i,:) = v_real;
        Q_all(i,:) = Q_real;
        Errv_real(i,:) = dv_real;
        Q_theo(i,:) = q_long;
    end
    
    fprintf('\n-------------------- Filament diameter calculation --------------------------\n');
    v_travel = v;%./9;
    for j=1:1:size(v_travel,2)
        D_fila = sqrt(4.*Q_all(j,:)./(pi*v_travel(j)));
        %fprintf('Filament diameters for v travel = %.2f mm/s \n',v_travel(j));
        %printTableInConsole(D_fila);
    end
    
    %Graphs ------------------------------------
    P = P./1000; % convert Pa to kPa and plot
    dP = dP./1000; % convert Pa to kPa and plot
%     plot_mode = 'latex';
    plot_mode = 'default';
    
    %Plot and compare with literature values to validate the model
%     if strcmpi(multinozzle,'y')
%         P_empty = multinozzleEmptyPressure(v); % Gets the multinozzle empty (no material) pressure (kPa)
%         P_lit = P_lit - P_empty;
%         P_max_multinozzle = P + P_empty';
%     end
    comparePlotPV(v,P,v,P_lit,[0 0],[0 0],dP,plot_mode);
    
    %Nozzle #1 is plotted here
    i = 1;
    comparePlotVisco(SR(:,i),eta(:,i),SR_lit,eta_lit,[0 0],[0 0],deta(:,i),dSR(:,i),plot_mode,i);
    
    % Bar plot per applied pressure/desired velocity combination for comparison between nozzle exit velocities
    % Velocity #1 is plotted here
    i = 1;
    compareBarPlotV(v_all(i,:),v(i),Errv_real(i,:),plot_mode,i);
end