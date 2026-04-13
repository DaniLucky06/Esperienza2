run('calcoli_statica');
mat = readmatrix('dati_dinamica.csv');

m = mat(1, :) / 1000;
m_ris = 0.1 / 1000;
m_err = m_ris / sqrt(12);

f_mat = mat(2:end, :);
T_mat = 1 ./ f_mat; % Senza errore, pk assumiamo le misure perfette

N = size(m, 2);
M = size(T_mat, 1);

T = mean(T_mat, 1);
T_std = std(T_mat, 0, 1); % ho sentito dire a uno del lab che è meglio usare N-1 (tecnicamentesì, ma boh??)
T_err = T_std / sqrt(M); % ridondante, ma l'ho messo così per far vedere che riteniamo l'unica fonte di errore la statistica

T2 = T .^ 2; % periodi al quadrato, per fit lineare
T2_err = 2 .* T .* T_err; % errore sui periodi quadri

x_err = m_err;
y_err = T2_err;
x = m;
y = T2;

% Varie somme
W = 1 ./ (y_err .^ 2); % "Pesi" - Weights
S_W   = sum(W);
S_XW  = sum(x .* W);
S_YW  = sum(y .* W);
S_XXW = sum((x .^ 2) .* W);
S_XYW = sum(x .* y .* W);

% Delta
D_W = S_W * S_XXW - S_XW^2;

% Fit iniziale
b = (1 / D_W) * (S_W * S_XYW - S_XW * S_YW);

% migliorare
y_err_i = sqrt(y_err .^ 2 + (b .* x_err) .^ 2); % errore 2
b_err = sqrt(S_W / D_W);
b1 = b + 2 * b_err;

while abs(b - b1) > b_err % loop di miglioramento (per k non parte nemmeno)
    y_err_i = sqrt(y_err .^ 2 + (b .* x_err) .^ 2);

    % Varie somme
    W = 1 ./ (y_err_i .^ 2); % "Pesi" - Weights
    S_W   = sum(W);
    S_XW  = sum(x .* W);
    S_YW  = sum(y .* W);
    S_XXW = sum((x .^ 2) .* W);
    S_XYW = sum(x .* y .* W);
    
    % Delta
    D_W = S_W * S_XXW - S_XW^2;

    b_err = sqrt(S_W / D_W);
    b1 = b;
    b = (1 / D_W) * (S_W * S_XYW - S_XW * S_YW);
end

% Intercetta
a = (1 / D_W) * (S_XXW * S_YW - S_XW * S_XYW);

% Errori su fit
a_err = sqrt(S_XXW / D_W);
b_err = sqrt(S_W / D_W); % errore finale

% Parametri equazioni
C_stat = sqrt(b * k); % C^2 = b * k, con il k statico
me_stat = a / b; % me = a * k / C^2 = a / b
C = 2 * pi;
k_din = C^2 / b;
me_din = a * k_din / C^2;

% Errori sui parametri
C_stat_err = sqrt((k / (2*sqrt(b * k)) * b_err)^2 + (b / (2*sqrt(b * k)) * k_err)^2); % DA RICONTROLLARE
me_stat_err = sqrt((a_err / b)^2 + (a / b^2 * b_err)^2); % DA RICONTROLLARE
k_din_err = C^2 / b^2 * b_err; % DA RICONTROLLARE
me_din_err = sqrt((k_din / C^2 * a_err)^2 + (a / C^2 * k_din_err)^2); % DA RICONTROLLARE

chi2 = sum(((y - (a + b.*x)) ./ y_err_i).^2);
chi2_rid = chi2 / (N - 2);

% Stimare l'errore medio a partire dal chi quadro
y_err_chi2 = sqrt(sum((y - (a + b.*x)).^2) / (N-2));