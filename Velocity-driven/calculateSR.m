function [SR,dSR] = calculateSR(Q,D,v)

%**************************************************************************
%calculateSR.m is the function used to obtain the shear rate inside
%multiple nozzles.
%**************************************************************************
%The output is the shear rate array (SR). The inputs are the flow rate
%array (Q), the nozzle diameter array (D)
%Author: David Brzeski, Jean-François Chauvette
%Date: June 13, 2020
%**************************************************************************

if isnumeric(Q) && isnumeric(D)
    SR = 32.*Q./(pi.*D(1,:).^3);
    dSR = 8*v.*D(2,:)./D(1,:).^2;
end

end