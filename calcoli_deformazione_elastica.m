% LUNGHEZZE IN METRI
% PESO IN KILOGRAMMI
% TENSIONE IN VOLT
% Per pulire tutte cose
clc
clear

% Eseguo il file startup
run('startup.m')

% --- ANALISI DATI PRIMA SEDUTA ---%

dati_1 = readmatrix('dati_deformazione_elastica_1.csv');

pesi_vet1 = dati_1(:,1) ./ 1000 .*g;
voltagi = dati_1(:,2);
indeterminazione = dati_1(:,3);
altezza = dati_1(:,4) ./ 100;

peso_molla1 = .199;
peso_molla2 = .205;

err_v = indeterminazione;
err_l = .0005 / sqrt(12);
err_m = .001 / sqrt(12);
err_P = err_m * g;

% Calcolo sensibilità

n = length(altezza);

delta = (n ./ err_l^2) .* (sum(pesi_vet1.^2)./ err_l^2) - (sum(pesi_vet1) ./ err_l^2).^2;

a = 1 / delta .* ((sum(pesi_vet1.^2 ./ err_l^2)) .* (sum(altezza ./ err_l^2)) - (sum(pesi_vet1 ./ err_l^2)) .* (sum(pesi_vet1 .* altezza ./ err_l^2)));
b = 1 / delta .* ((n / err_l^2) .* (sum(pesi_vet1 .* altezza ./ err_l^2)) - (sum(pesi_vet1 ./ err_l^2)) .* (sum(altezza ./ err_l^2)));

sigma_a = sqrt(1 / delta .* sum(pesi_vet1.^2) ./ err_l^2);
sigma_b = sqrt(1 / delta * n * err_l^2);
b_1 = b + 2 * sigma_b;
sigma_y = err_l;

while b_1 - b > sigma_b
    sigma_y = sqrt(err_l^2 + (b^2 .* (err_P)));
    b = 1 / delta .* (sum(1 ./ sigma_y.^2) .* (sum(pesi_vet1 .* altezza ./ sigma_y.^2)) - (sum(pesi_vet1 ./ sigma_y.^2)) .* (sum(altezza ./ sigma_y.^2)));
end

k = 1 / b;

% --- ANALISI DATI SECONDA SEDUTA ---%

dati_2 = readmatrix('dati_deformazione_elastica_2.csv');

masse_vet2 = dati_2(1,:);

periodi_mx = 1 ./ dati_2(2:end,:);
periodi_medi_vet = mean(periodi_mx, 1);