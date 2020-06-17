function [rho, w, f, n, k, eta_inf, eta_0, tau_0, lambda, a] = readMaterial(file, sheet)

%**************************************************************************
%readMaterial.m is the function used to extract the informations about a
%specific material from the material database
%**************************************************************************
%The output is a cell containing the material properties.
%The inputs are the database file, the sheet name (material)
%Author: David Brzeski, Jean-François Chauvette
%Date: 2020-05-25
%**************************************************************************

% Lecture des données
[~, ~, raw] = xlsread(file, sheet, 'A1:C10');

% Attribution des données aux variables
rho = raw{1,2};
w = raw{2,2};
f = raw{3,2};
n = raw{4,2};
k = raw{5,2};
eta_inf = raw{6,2};
eta_0 = raw{7,2};
tau_0 = raw{8,2};
lambda = raw{9,2};
a = raw{10,2};

end