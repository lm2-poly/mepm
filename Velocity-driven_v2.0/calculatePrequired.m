function [P] = calculatePrequired(R_eq,Q_eq,P_amb)

%**************************************************************************
%calculatePrequired.m is the function used to obtain the required pressure
%to extrude material through the equivalent flow resistance network
%caracterized by the nozzles in parallel.
%**************************************************************************
%The output is the required pressure (P).
%The inputs are the equivalent flow resistance (R_eq), the equivalent total
%flow rate (Q_eq) and the ambiant pressure (P_amb).
%Author: David Brzeski, Jean-François Chauvette
%Date: June 13, 2020
%**************************************************************************

if isnumeric(R_eq) &&  isnumeric(Q_eq) && isnumeric(P_amb)
    P = (R_eq*Q_eq+P_amb);
end

end