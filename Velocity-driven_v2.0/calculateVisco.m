function [eta,deta] = calculateVisco(SR,n,K,eta_inf,eta_0,tau_0,lambda,a,debug_mode,dSR)

%**************************************************************************
%calculateVisco.m is the function used to obtain the apparent viscosity
%inside a every nozzle, depending on the material's bahaviour law.
%**************************************************************************
%The output is the apparent viscosity array (eta). The inputs are the shear
%rate (SR), the viscosity index (n), the consistency index (K), the
%infinite viscosity (eta_inf), the rest-state viscosity (eta_0), the creep
%factor (tau_0, the relaxation time (lambda) and the Carreau model exponent (a).
%Author: David Brzeski, Jean-François Chauvette
%Date: June 13, 2020
%**************************************************************************
%for debugging purposes, the following errors are defined (later = Excel):
%Note: delta eta not yet defined for Carreau, Bingham, & Herschell-Bulkley 
%(extended)models
dK = 10;
dn = 0.01;
deta_inf = 10;

if isnumeric(SR) &&  isnumeric(n) && isnumeric(K) && isnumeric(eta_inf)...
        && isnumeric(tau_0) && isnumeric(eta_0) && isnumeric(lambda) && isnumeric(a)
    
    if n~=0 && K~=0 && eta_inf~= 0 && eta_0==0 && tau_0==0 && lambda==0 && a==0
        eta = K.*SR.^(n-1)+eta_inf; %Sisko model
        deta = sqrt((SR.^(n-1).*dK).^2+(K*(n-1).*SR.^(n-2).*dSR).^2+(K.*SR.^(n-1).*log(SR)*dn).^2+deta_inf^2);
        if debug_mode
            fprintf('Sisko model is used\n');
        end
    elseif n==1 && K==0 && eta_inf~=0 && eta_0==0 && tau_0==0 && lambda==0 && a==0
        eta = eta_inf; %Newtonian model
        deta = deta_inf;
        if debug_mode
            fprintf('Newtonian model is used\n');
        end
    elseif n~=0 && K~=0 && eta_inf==0 && eta_0==0 && tau_0==0 && lambda==0 && a==0
        eta = K.*SR.^(n-1); %Pure power law model
        deta = sqrt((SR.^(n-1).*dK).^2+(K*(n-1).*SR.^(n-2).*dSR).^2+(K.*SR.^(n-1).*log(SR)*dn).^2);
        if debug_mode
            fprintf('Ostwald-de-Waele model (pure power law) is used\n');
        end
    elseif n~=0 && K==0 && eta_inf~=0 && eta_0~=0 && tau_0==0 && lambda~=0 && a~=0
        eta = eta_inf+(eta_0-eta_inf).*(1+(lambda.*SR).^a).^((n-1)/a); %Carreau model
        ratio = 1+(lambda.*SR)^a;
        deta1 = ((1-ratio^((n-1)/a))*deta_inf)^2;
        deta2 = (1)^2;
        deta3 = (1)^2;
        deta4 = (1)^2;
        deta5 = (1)^2;
        deta = sqrt(deta1+deta2+deta3+deta4+deta5);0; % 0 by default for now
        if debug_mode
            fprintf('Carreau model is used\n');
        end
    elseif n==1 && K==0 && eta_inf~=0 && eta_0==0 && tau_0~=0 && lambda==0 && a==0
        eta = tau_0./SR+eta_inf; %Bingham model
        deta = 0; % 0 by default for now
        if debug_mode
            fprintf('Bingham model is used\n');
        end
    elseif n~=0 && K~=0 && eta_inf~=0 && eta_0==0 && tau_0~=0 && lambda==0 && a==0
        eta = tau_0./SR+K.*SR.^(n-1)+eta_inf; %Herschell-Bulkley extended model
        deta = 0; % 0 by default for now
        if debug_mode
            fprintf('Herschell-Bulkley extended model is used\n');
        end
    elseif n~=0 && K~=0 && eta_inf==0 && eta_0==0 && tau_0~=0 && lambda==0 && a==0
        eta = tau_0./SR+K.*SR.^(n-1); %Herschell-Bulkley model
        deta = 0; % 0 by default for now
        if debug_mode
            fprintf('Herschell-Bulkley model is used\n');
        end
    else
        error('No model was found for your material');
    end
end

end
