% Lunghezza - cm (risoluzione 0.05 cm);
% Voltaggio - V (risoluzione BOH);
% Massa - grammi (risoluzione 0.1 g).

% Pulisco la console e svuoto le variabili
clear
clc

% --- ANALISI DATI --- %

% Eseguo il file startup.m, contiene variabili generalmente utili
run('/Users/giacomovanzelli/MATLAB/startup.m');

dati = readtable('/Users/giacomovanzelli/MATLAB/Deformazione elastica/dati_deformazione_elastica.csv');
massa_molla = 21.1;

% Risoluzioni
ris_m = .01;
ris_l = .05;

% Errori sulle risoluzioni
err_ris_m = ris_m / sqrt(12);
err_ris_l = ris_l / sqrt(12);

% Conversione dei pesi in newton
dati.massa = dati.massa .* g / 1000;

% -- CALCOLO K --- %
% Modello 1:
