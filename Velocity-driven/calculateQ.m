function [Q,dQ,Q_eq] = calculateQ(D,v)

%**************************************************************************
%calculateQ.m is the function used to obtain the volumetric flow rate thru
%several nozzle.
%**************************************************************************
%The output is a flow rate array for each of the nozzles (Q). The inputs
%are the nozzle diameter array (D), the desired speed for all nozzles(v).
%Author: David Brzeski, Jean-François Chauvette 
%Date: June 13, 2020
%**************************************************************************

    if isnumeric(D) && isnumeric(v)
        area = pi().*(D(1,:)./2).^2;
        Q = area(1,:).*v; % Calculation of the individual flow rate
        dQ = pi*0.5.*D(1,:).*D(2,:).*v;
        Q_eq = sum(Q);% Calculation of the total equivalent flow rate
    end

end