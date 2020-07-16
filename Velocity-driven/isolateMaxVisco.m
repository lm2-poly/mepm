function [eta_map] = isolateMaxVisco(L,D,Req_map)
%isolateMaxVisco.m Calculates the viscosity of the material (treated as a
%black box, with unknown behaviour) based on the equivalent resistence of
%the multinozzle system.
%Creator: David Brzeski
%Date:16-07-2020

if nargin == 3
    if ismatrix(L) && ismatrix(D) && ismatrix(Req_map)
        eta_map = zeros(size(D,2),2);
        sum_dia = 0;
        error_sum = 0;
        for j = 1:size(D,2)
            sum_dia = sum_dia+D(1,j)^4;
            error_sum = error_sum+4*D(1,j)^3;
        end
        for i=1:size(D,2)
            eta_map(i,1) = pi*Req_map(i,1)*sum_dia/(L(1,i)*128);
            eta_map(i,2) = (Req_map(i,2)*sum_dia*pi/128/L(1,i))^2+...
                (Req_map(i,1)*pi*L(2,i)*sum_dia/(128*L(1,i)^2))^2+...
                (Req_map(i,1)*pi*error_sum*(D(2,i))/(128*L(1,i)^2))^2;
        end
    end
end
end

