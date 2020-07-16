function [Req_map] = isolateReq(P_allowable,Q,dQ)
%isolateReq.m Calculates the equivaent resistance of the mutlinozzle based
%on flow a flow rate vector (indices represents nozzles) and maximum
%allowable pressure.
%Creator: David Brzeski
%Date:16-07-2020

if nargin == 3
    if isnumeric(P_allowable) && isvector(Q) && isvector(dQ)
        Req_map = zeros(length(Q),2);
        for i=1:length(Q)
            Req_map(i,1) = P_allowable*Q(i);
            Req_map(i,2) = P_allowable*dQ(i)/Q(i)^2/1000;
        end
    end
end
end