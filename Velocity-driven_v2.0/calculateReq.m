function [R_eq,Ri] = calculateReq(eta,L,D)

%**************************************************************************
%calculateReq.m is the function used to obtain the equivalent hydraulic
%resistance of several nozzles in parallel.
%**************************************************************************
%The output is the equivalent hydraulic resistance (R_eq). The inputs are
%the apparent viscosity array (eta), the nozzle length array (L), the
%nozzle diameter array (D).
%Author: David Brzeski, Jean-François Chauvette
%Date: June 13, 2020
%**************************************************************************

if isnumeric(eta) &&  isnumeric(L) && isnumeric(D)
    Ri = (128.*L(1,:).*eta)./(pi.*D(1,:).^4);
    R_eq = 1/sum(1./Ri);
end

end