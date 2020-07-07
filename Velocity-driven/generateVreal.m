function [v_real, Q_real,dv_real,Q_theo] = generateVreal(P, dP, Q, rho, v, D, L, n, K, eta_0, eta_inf, tau_0, lambda, a, P_amb, debug_mode)

%**************************************************************************
% generateVreal.m
% Last updated : 2020-06-13
%**************************************************************************
%
% 
% Author: Jean-François Chauvette, David Brzeski
% Date: June 13, 2020
%**************************************************************************

fprintf('\n-------------------- True velocity calculation --------------------------\n');
fprintf('<strong>Desired</strong> nozzle exit speed (mm/s) = %.2f\n',v);
fprintf('Real applied pressure (Pa) = %.0f\n\n',P);

Q_real = zeros(1,size(D,2)); % Array of true recalculated flow rate
eta_real = zeros(1,size(D,2)); % Array of true recalculated shear rates
Q_theo = zeros(1,size(D,2)); % Array of theoretical recalculated flow rate
dQ_crit = 10^-4;    % Convergence criterion for true flow rate recalculation

for i=1:size(D,2) % Iteration on all nozzle for a given P/v combination
    if debug_mode
        fprintf('<strong>Nozzle #%i -----------------------</strong>\n',i);
    end
    variattion_Q = dQ_crit+1; % Initializing a first dummy delta Q just to enter the while loop
    nbIter = 0; % Number of iteration needed for convergence
    Q_guess = Q(i); % The initial Q guess = the previously desired Q for each nozzle (at desired input nozzle exit velocity)
    
    while variattion_Q >= dQ_crit % Keep recalculating Q until it converges
        nbIter = nbIter + 1;
        if debug_mode
            fprintf('Iteration #%i\n',nbIter);
        end
        
        % Intermediate calculations
        [SR_temp,~] = calculateSR(Q_guess,D,0); % Shear rate
        [eta_temp,deta_temp] = calculateVisco(SR_temp,n,K,eta_inf,eta_0,tau_0,lambda,a,debug_mode,0); % Viscosity
        [~,Ri] = calculateReq(eta_temp,L(1,i),D); % Nozzle flow resistance
        [~,dRi] = calculateReqError(0,Ri,size(D,2),D,L,eta_temp,deta_temp);
        Q_temp = (P-P_amb)/Ri(i); % Temporary Q for comparison with criterion
        dQ_temp = (dP./Ri(i))^2+((P-P_amb)*dRi(i)/Ri(i)^2)^2;
        variattion_Q = abs(Q_temp - Q_guess)/Q_guess; % Delta Q with previous guess
        Q_guess = Q_temp; % New Q guess
        
        if debug_mode
            fprintf('Q_temp_%i = %.4f\n',nbIter,Q_temp);
            fprintf('dQ_%i = %.8f\n',nbIter,variattion_Q);
        end
    end
    Q_real(i) = Q_temp;
    Q_theo(i) = (pi*n/(3*n+1))*(D(1,(i))/2)^((1+3*n)/n)*...
        ((P-P_amb+rho*9.81*L(1,(i))/1000)/(2*K*L(1,(i))))^(1/n); %calculates theoretical Q based on the big formula
    Q_guess_error = dQ_temp;
    eta_real = eta_temp;
end
% Calculate v real, Q real and print table in console
v_real = Q_real./(0.25*pi.*D(1,:).^2);
dv_real = ((Q_guess_error./(pi*4.*D(1,:).^2)).^2)+((D(2,:).*Q_temp)./(pi*4.*D(1,:).^3)).^3;
%v_theo = Q_theo./(0.25*pi.*D(1,:).^2);
fprintf('Real nozzle exit velocities (mm/s):\n');
printTableInConsole(v_real);
% fprintf('Theoretical nozzle exit velocities (mm/s):\n');
%printTableInConsole(v_theo);
fprintf('Real nozzle exit flow rates (mm³/s):\n');
printTableInConsole(Q_real);
%fprintf('Theoretical nozzle exit flow rates (mm³/s):\n');
%printTableInConsole(Q_theo);

% Renolds number hypothesis validation
[~,Re] = validateReynolds(rho, v_real, D, eta_real, debug_mode);
if debug_mode
    fprintf('Reynold numbers:\n');
    printTableInConsole(Re);
end

end

