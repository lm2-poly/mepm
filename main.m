%**************************************************************************
% main script
% Last updated : 2021-04-02
%**************************************************************************
% Description : General script that talks to other scripts, queries the
% database and interacts with the user. Also provides user feedback.
%
% Instructions:
%       This script must be used with the materialsDB.xls database.
%       Follow the instructions in the Matlab console.
%
% Authors: Jean-François Chauvette, David Brzeski
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
graph_mode = 'S'; % Determines which graph to plot. 
                  %     P = Pressure vs. Speed
                  %     V = Viscosity vs. Shear rate
                  %     S = Printing Speed vs. nozzle ID number
                  %     Q = Mass flow rate vs. printing speed

% Ambiant pressure, [Pa]
P_amb = 101325; 

% Multinozzle geometry
alpha = 26;
D = [0.257193333	0.25623	0.25612	0.256406667	0.25561	0.25561	0.25612	0.255536667	0.255376667	0.25357	0.25459	0.25561	0.2551	0.25663	0.25459	0.2551	0.25255	0.25408	0.25357	0.25459	0.25816	0.25459	0.25663	0.25765	0.25714	0.25459];
D(2,:) = 0.001*ones(1,alpha); % Error on the nozzles diameter at D(1,:)
D_avg = [mean(D(1,:))*ones(1,alpha); mean(D(2,:))*ones(1,alpha)];
L = [6.5*ones(1,alpha);0.01*ones(1,alpha)]; % The nozzles length is assume to be equal to 6.5 mm with a 0.01 mm error

% Simulation a clogged nozzle. The substracted reduction is in mm.
D(1,6) = 0.9*D(1,6);
% D(1,6) = D(1,6) - 0.050;
% D(1,7) = D(1,7) - 0.050;

% Desired printing speed
v = [50 100	150	200	250];   % mm/s
% v = [0 1 2 3 4 5 6 7 8 9 10 20 30 40 50 100 150 200 250 300 500 1000 1500 2000];   % mm/s

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
    
    % Initialization of literature data for comparison
    validation_infos_star;
    
    % Calculating the maximum capable speed for the given diameters
%     D_reservoir = 28.5; % mm
%     A_reservoir = 0.25*pi()*D_reservoir^2; % mm²
%     A_for250um26nozzles = 26*0.25*pi()*0.25^2; % mm²
%     v_max_for250um26nozzles = 250 ; % mm/s, known value from experimental data
%     v_max_piston = v_max_for250um26nozzles * A_for250um26nozzles / A_reservoir; % mm/s    
%     A_nozzles = sum(0.25*pi().*(D(1,:).^2));
%     v_max = v_max_piston*A_reservoir/(A_nozzles);
%     v = linspace(0,v_max,20);
%     v = [linspace(0,v(2),100), v(3:end)];
%     v = [0:0.1:1, 2:1:10, 20:10:100, v(3:end)];
  
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
    
    % Compute true velocity and flow rate for nozzle true applied pressure
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
    
    if contains(graph_mode,'P')
        comparePlotPV(v,P,v,P_lit,[0 0],[0 0],0,plot_mode);
    %     comparePlotPV(v,P,v,P_lit,[0 0],[0 0],dP,plot_mode);
    end
    
    %Nozzle #i is plotted here
    if contains(graph_mode,'V')
    %     i = alpha;
    %     comparePlotVisco(SR(:,i),eta(:,i),SR_lit,eta_lit,[0 0],[0 0],deta(:,i),dSR(:,i),plot_mode,i);
        comparePlotVisco(mean(SR,2),mean(eta,2),SR_lit,eta_lit,[0 0],[0 0],mean(deta,2),mean(dSR,2),plot_mode,i);
    end
    
    % Bar plot per applied pressure/desired velocity combination for comparison between nozzle exit velocities
    % Velocity #i is plotted here
    if contains(graph_mode,'S')
        %i = size(v,2); % Plotting the last printing speed
        i = 1;
        compareBarPlotV(v_all(i,:),v(i),0,plot_mode,i);
    %     compareBarPlotV(v_all(i,:),v(i),Errv_real(i,:),plot_mode,i);
    end
    
    % Plot of total mass flow rates
    Q_real_tot = sum(Q_all,2); % sum of all nozzle's Q in mm³/s
    Q_real_m = Q_real_tot .* rho * 1e-6; % mass flow rate conversion from mm³/s to g/s
    if contains(graph_mode,'Q')
        comparePlotQ(v,Q_real_m,v,Q_lit,[0 0],[0 0],0,plot_mode);
    end
end