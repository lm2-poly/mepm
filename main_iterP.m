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
% Authors: David Brzeski, Jean-Fran�ois Chauvette
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
debug_mode = 0; % To print in the console all the intermediate values for calculation
dP_crit = 10^-4; % Error margin for Pressure calculation

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
    
    % Script call for testing purposes (auto-completion of alpha, D, L,
    % P_amb and v values).
    validation_infos;
    
    % Request the printing head informations
    % %     D = validUserInput('Enter the nominal nozzle inner diameter (mm) : ',1);
    %     D_real = validUserInput('Enter the array ([a,b,c,...]) of measured nozzle inner diameter (mm) : ',1);
    % %     L = validUserInput('Enter the nominal nozzle length (mm) : ',1);
    %     L_real = validUserInput('Enter the array ([a,b,c,...]) of measured nozzle length (mm) : ',1);
    %     P_amb = validUserInput('Enter the ambiant pressure (Pa) : ',1);
    
    % Request a printing velocity
    %     v = validUserInput('Enter an array of nominal desired extrusion velocity for the nozzles (mm/s) : ',1);
    
    % Preallocation
    %     D = D_real;%D*ones(1,size(D_real,2)); % Vector of theoretical nozzle diameters for overall P computation
    %     L = L_real;%L*ones(1,size(L_real,2)); % Vector of theoretical nozzle lengths for overall P computation
%     P_lit = [600,900,1100,1300,1500,1950,2250,2500];  % Literature values to compare to
%     SR_lit = [35,76,160,300,500,700,1100]; % Literature values to compare to
%     eta_lit = [120,82,55,38,28,22,16]; % Literature values to compare to
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
    D_avg = [0.25*ones(1,size(D,2));0.01*ones(1,size(D,2))];
    D_current = D_avg;
    
    variation_P = dP_crit + 1;
    nbIter = 0; % Number of iteration needed for convergence
    P_guess = 0;
    
    fprintf('======================================================================================');
    while variation_Q >= dQ_crit % Keep recalculating Q until it converges
        nbIter = nbIter + 1;
        %if debug_mode
            fprintf('Iteration Pressure #%i\n',nbIter);
        %end
        
        for i=1:1:size(v,2)
            [newP,newEta,newSR,newQ,newdEta,newdP,newdRi,newdSR] = ...
                generateP(rho, v(i), D_current, L, n, K, eta_0, eta_inf, tau_0, lambda, a, P_amb, debug_mode);
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
        P_temp = P;
    
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
        
        variation_P = abs(P_temp - P_guess)/P_guess; % Delta P with previous guess
        P_guess = P_temp; % New Q guess
        D_current = D;
        
        if debug_mode
            fprintf('Q_temp_%i = %.4f\n',nbIter,P_temp);
            fprintf('dQ_%i = %.8f\n',nbIter,variation_Q);
        end
    end
    
    fprintf('\n-------------------- Filament diameter calculation --------------------------\n');
    v_travel = v;%./9;
    for j=1:1:size(v_travel,2)
        fprintf('Filament diameters for v travel = %.2f mm/s \n',v_travel(j));
        D_fila = sqrt(4.*Q_all(j,:)./(pi*v_travel(j)));
        printTableInConsole(D_fila);
    end
    
    %Graphs ------------------------------------
    P = P./1000; % convert Pa to kPa and plot
    dP = dP./1000; % convert Pa to kPa and plot
%     plot_mode = 'latex';
    plot_mode = 'default';
    
    %Plot and compare with literature values to validate the model
    %Nozzle #1 is plotted here
    comparePlotPV(v,P,v,P_lit,[0 0],[0 0],dP,plot_mode);
    %%
    i = 5;
    comparePlotVisco(SR(:,i),eta(:,i),SR_lit,eta_lit,[0 0],[0 0],deta(:,i),dSR(:,i),plot_mode,i);
    
    % Bar plot per applied pressure/desired velocity combination for comparison between nozzle exit velocities
    % Velocity #1 is plotted here
    i = 5;
    compareBarPlotV(v_all(i,:),v(i),Errv_real(i,:),plot_mode,i);
end