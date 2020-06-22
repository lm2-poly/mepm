function [P,eta,SR,Q,deta,dP,dRi,dSR] = generateP(rho, v, D, L, n, K, eta_0, eta_inf, tau_0, lambda, a, P_amb, debug_mode)

%**************************************************************************
% generateP.m
% Last updated : 2020-06-13
%**************************************************************************
% This function's purpose is to regroup all the necessary function calls in
% order to calculate the required pressure for a given material and nozzle
% exit velocity. It validates the Reynold numbers. Finally, it returns the
% required Pressure along with Viscosities and Shear rates arrays for plots.
% 
% Author: Jean-François Chauvette
% Date: June 13, 2020
%**************************************************************************

fprintf('------------------------------------------------------------------------------------------------\n')
fprintf('Desired nozzle exit speed (mm/s) = %.2f\n\n',v);

% Flows computation
[Q,dQ] = calculateQ(D,v);
Q_eq = sum(Q); % Calculation of the total equivalent flow rate
dQ_eq = sqrt(sum(dQ.^2));
if debug_mode
    fprintf('Total equivalent Q (mm³/s) = %.2f\n',Q_eq);
    fprintf('Volumetric flow rates (mm³/s):\n');
    printTableInConsole(Q);
end

% Shear rate computation (réel)
[SR,dSR] = calculateSR(Q,D,v);
if debug_mode
    fprintf('Shear rates (1/s):\n');
    printTableInConsole(SR);
end

% Viscosity computation
[eta,deta] = calculateVisco(SR,n,K,eta_inf,eta_0,tau_0,lambda,a,debug_mode,dSR);
if debug_mode
    fprintf('Viscosities (Pa.s):\n');
    printTableInConsole(eta);
end

% Equivalent flow resistance computation
[R_eq,Ri] = calculateReq(eta,L,D);
[R_eq_error,dRi] = calculateReqError(R_eq,Ri,size(D,2),D,L,eta,deta); 
if debug_mode
    fprintf('Total equivalent R (Pa.s/mm³) = %.2f\n',R_eq);
    fprintf('Individual flow resistances (Pa.s/mm³):\n');
    printTableInConsole(Ri);
end

% Renolds number hypothesis validation
[typeEcoul,Re] = validateReynolds(rho, v, D, eta, debug_mode);
if debug_mode
    fprintf('Reynold numbers:\n');
    printTableInConsole(Re);
end

if typeEcoul == 0 % Laminar flow    
    % Required pressure computation
    P = calculatePrequired(R_eq,Q_eq,P_amb);
    dP = sqrt((R_eq_error*Q_eq)^2+(R_eq*dQ_eq)^2);
    fprintf('<strong>Required pressure (Pa) = %.0f</strong>\n',P);    
else % Transition flow, turbulent flow or negative Reynolds
    P = nan;
end

end