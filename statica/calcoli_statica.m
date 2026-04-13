% LUNGHEZZE IN METRI
% PESO IN KILOGRAMMI
% TENSIONE IN VOLT
dati = readmatrix('dati_statica.csv');

m = dati(:,1) ./ 1000;
P = m .* g;
V = dati(:,2);
h = -dati(:, 4) ./ 100;
N = size(h, 1);

% Risoluzioni
m_ris = 0.0001;
h_ris = 0.0005;

% Incertezze/errori/sigmae
m_err = m_ris / sqrt(12);
P_err = m_err .* g; % scalare
h_err = h_ris / sqrt(12); % scalare
V_err = dati(:, 3); % vettore

% --- CALCOLO K --- %

% Varie somme
SX = sum(P);
SSQX = sum(P .^ 2);
SY = sum(h);
SXY = sum(P .* h);

% Errori su x e y
y_err = h_err;
x_err = P_err;

% Delta
D_k = N * SSQX - SX .^ 2;

% Coefficienti del fit
b = 1 / D_k * (N * SXY - SX * SY);
a = 1 / D_k * (SSQX * SY - SX * SXY);

b_err = y_err * sqrt(SSQX / D_k);
a_err = y_err * sqrt(N / D_k);

% migliorare?
b1 = b - 2 * b_err;

while b - b1 > b_err
    y_err_i = sqrt(y_err ^ 2 + (b * x_err) ^ 2);
    b_err = y_err_i * sqrt(SSQX / D_k);
    b1 = b;
    b = 1 / D_k * (N * SXY - SX * SY);
end