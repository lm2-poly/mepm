function [P] = multinozzleEmptyPressure(v,pos)

%**************************************************************************
%adjustPressure.m
%
%The function used to adjust the measured pressures with the multinozzle in
%order to match the model prediction.
%
%The function uses a linear fit to the required pressure for moving the
%bare piston (without any material) at velocities ranging from 50 to 250
%mm/s. The piston pressure is substracted to the meaured pressure to asses
%the true required pressure for the material to extrude.
% 
%IMPORTANT : the pressure unit is Pascal and mm/s for velocity
%**************************************************************************
%   output : adjusted pressure array (P_adjusted). 
%	inputs : calculated pressures P for each velocities 
%            velocities v array
%Author: Jean-François Chauvette
%Date: OCtober 25th, 2020
%**************************************************************************
    
    % Add the MINIMUM pressure surplus
    P_min = 22.954.*v + 1012.8; % Empirical relation of P and velocity at nozzle exit for the start of the piston's course
    %P_max = 23.204.*v + 1732.8; % Empirical relation of P and velocity at nozzle exit for the end of the piston's course
    P = P_min;
end

