% Pulisco la console e svuoto le variabili
clear
clc

% Eseguo il file calcoli_deformazione_lineare.m
run('/Users/giacomovanzelli/MATLAB/Deformazione elastica/calcoli_deformazione_elastica.m');

% --- REGRESSIONE LINEARE --- %
var_m = var(dati.massa, 1);
covar = cov(dati.massa, dati.voltaggi, 1);

b = covar(1, 2) / var_m;
a = mean(dati.voltaggi) - b * mean(dati.massa);

x_space = linspace(0, 2, 20);

hold on;
    grid on;
    plot(x_space, a + b .* x_space, 'LineWidth', 1)
    plot(dati.massa, dati.voltaggi, 'x', 'MarkerSize', 15, 'LineWidth', 1);
hold off;