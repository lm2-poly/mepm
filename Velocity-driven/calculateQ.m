function [Q,dQ] = calculateQ(D,v)

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
        area = pi().*0.25.*D(1,:).^2;
        Q = area(1,:).*v;
        dQ = pi*0.5.*D(1,:).*D(2,:).*v;
    end

end