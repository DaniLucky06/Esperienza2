% LUNGHEZZE IN METRI
% PESO IN KILOGRAMMI
% TENSIONE IN VOLT
dati = readmatrix('dati_statica.csv');
dati = dati(1:end, :); % scartare il primo (regime non lineare?)

m_molla1 = .0199; % senza anelli
m_molla2 = .0205; % con anelli

m = dati(:,1) ./ 1000;
m = m + m_molla2 ./ 2; % non cambia il calcolo di k, ma di a sì
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
% Errori su x e y
y_err = h_err;
x_err = P_err;

% Varie somme
S_X = sum(P);
S_XX = sum(P .^ 2);
S_Y = sum(h);
S_XY = sum(P .* h);

% Delta
D_k = N * S_XX - S_X .^ 2;

% Pendenza del fit, iniziale
b = 1 / D_k * (N * S_XY - S_X * S_Y);

% migliorare?
y_err_i = sqrt(y_err .^ 2 + (b .* x_err) .^ 2); % errore 2
b_err = y_err_i .* sqrt(N / D_k); % errore aggiornato

b_k = 1 / D_k * (N * S_XY - S_X * S_Y);
a_k = 1 / D_k * (S_XX * S_Y - S_X * S_XY);
k = 1 / b;

a_k_err = y_err_i * sqrt(S_XX / D_k);
b_k_err = b_err; % errore finale
k_err = 1 / b^2 * b_err;

y_k_err = sqrt(y_err .^ 2 + (b_k .* x_err) .^ 2); % errore finale contando la x

chi2_k = sum(((h - (a_k + b_k.*P)) ./ y_k_err).^2);
chi2_k_rid = chi2_k / (N - 2);


% --- CALCOLO SENSIBILITA' --- %
% Errori su x e y
y_err = V_err;
x_err = P_err;

% Varie somme
W = 1 ./ (y_err .^ 2); % "Pesi" - Weights
S_W   = sum(W);
S_XW  = sum(P .* W);
S_YW  = sum(V .* W);
S_XXW = sum((P .^ 2) .* W);
S_XYW = sum(P .* V .* W);

% Delta
D_W = S_W * S_XXW - S_XW^2;

% Fit iniziale
a = (1 / D_W) * (S_XXW * S_YW - S_XW * S_XYW);
b = (1 / D_W) * (S_W * S_XYW - S_XW * S_YW);

% migliorare
y_err_i = sqrt(y_err .^ 2 + (b .* x_err) .^ 2); % errore 2
b_err = sqrt(S_W / D_W); % errore aggiornato
b1 = b + 2 * b_err;

while abs(b - b1) > b_err % loop di miglioramento (per k non parte nemmeno)
    y_err_i = sqrt(y_err .^ 2 + (b .* x_err) .^ 2);

    % Varie somme
    W = 1 ./ (y_err_i .^ 2); % "Pesi" - Weights
    S_W   = sum(W);
    S_XW  = sum(P .* W);
    S_YW  = sum(V .* W);
    S_XXW = sum((P .^ 2) .* W);
    S_XYW = sum(P .* V .* W);
    
    % Delta
    D_W = S_W * S_XXW - S_XW^2;

    b_err = sqrt(S_W / D_W);
    b1 = b;
    b = (1 / D_W) * (S_W * S_XYW - S_XW * S_YW);
end

a_V = (1 / D_W) * (S_XXW * S_YW - S_XW * S_XYW);
b_V = b; % Sensibilità: V/N
S = 1 / b; % Fattore di conversione: N/V, V-->N

a_V_err = sqrt(S_XXW / D_W);
b_V_err = sqrt(S_W / D_W); % errore finale
S_err = 1 / b^2 * b_V_err;

chi2_V = sum(((V - (a_V + b_V.*P)) ./ y_err_i).^2);
chi2_V_rid = chi2_V / (N - 2);