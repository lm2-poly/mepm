function [typeEcoul,Re]= validateReynolds(rho, v, D, eta, debug_mode)

%**************************************************************************
%validateReynolds.m is the function used to validate whether a laminar flow
%is occuring in the the nozzles of the robot. Upon validation, the Hagen-
%Poiseuille viscosity formulation may be used. If any of the flow rates are
%in the transition zone or turbulent, the function returns the position of
%nozzles having non laminar flow.
%**************************************************************************
%The output is the flow type, 0=laminar, 1=transition zone, 2=turbulent.
%pos is the position array of nozzles having non laminar flow.
%Function valid only for the Extended Herschell-Bulkley, Herschell-Bulkley,
%Sisko, Ostwald-de-Waele, Bingham and Newtonian models.
%Author: David Brzeski, Jean-François Chauvette
%Date: June 13, 2020
%**************************************************************************

if isnumeric(rho) && isnumeric(v) && isnumeric(D) && isnumeric(eta)
    if rho == 0
        warning('Reynolds validation is skipped since rho = 0. Update material database to activate Reynolds validation.');
        typeEcoul = 0;
        Re = nan;
    else
        Re = rho*v.*D(1,:)./eta;
        Re = Re./10^6; % To render unitless, since rho is in kg/m³ and viscosity is in Pa.s (kg/m.s)
        
        if all(Re>0) && all(Re<100) % Laminar
            typeEcoul = 0;
            if debug_mode
                fprintf('All flow rates are laminar\n')
            end
        elseif any(Re>=100 & Re<=2500) % Transition
            typeEcoul = 1;
            pos = find(Re>=100 & Re<=2500);
            warning('The flow is in the transition zone for nozzles # %s',strjoin(string(pos),','))
        elseif any(Re>2500) % Turbulent
            typeEcoul = 2;
            pos = find(Re>2500);
            warning('The flow is turbulent for nozzles # %s',strjoin(string(pos),','))
        else % Negative Re number
            typeEcoul = nan;
            warning('Reynolds is negative');
        end
    end
end

end

