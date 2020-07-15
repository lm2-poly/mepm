function [eta_map] = isolateMaxVisco(L,D,Req_map)
%isolateMaxVisco.m Calculates the viscosity of the material (treated as a
%black box, with unknown behaviour) based on the equivalent resistence of
%the multinozzle system.
%Creator: David Brzeski
%Date:16-07-2020

if nargin == 3
    if ismatrix(L) && ismatrix(D) && ismatrix(Req_map)
        eta_map = zeros(1,size(D,2));
        sum_dia = 0;
        for j = 1:size(D,2)
            sum_dia = sum_dia+D(j,1)^4;
        end
        for i=1:size(D,2)
            eta_map(i,1) = pi*Req_map(i,1)*sum_dia/(L(i,1)*128);
            eta_map(i,2) = P_allowable*dQ(i)/Q(i)^2/1000;
        end
    end
end
end

