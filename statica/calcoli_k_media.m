% LUNGHEZZE IN METRI
% PESO IN KILOGRAMMI
% TENSIONE IN VOLT

clc

dati = readmatrix('dati_statica.csv');
dati = dati(1:end, :); % scartare il primo (regime non lineare?)

m_molla1 = .0199; % senza anelli
m_molla2 = .0205; % con anelli

m = dati(:,1) ./ 1000;
P = m(2:end) .* g;
P_0 = m(1) .* g;
V = dati(:,2);
h = -dati(2:end, 4) ./ 100;
h_0 = -dati(1,4) ./ 100;
N = size(h, 1);

% Risoluzioni
m_ris = 0.0001;
h_ris = 0.0005;

% Incertezze/errori/sigmae
m_err = m_ris / sqrt(12);
P_err = m_err .* g; % scalare
h_err = h_ris / sqrt(12); % scalare
h_err = h_err * sqrt(2);

h = h - h_0;
k_i = (P - P_0) ./ h;
k_err_i = sqrt( ...
    ((1./h) .* P_err).^2 + ... % Pi
    ((-1./h) .* P_err).^2 + ... % P0
    ((-(P - P_0)./h.^2) .* h_err).^2 ... % h
);

w_i = 1 ./ k_err_i.^2;
S_w = sum(w_i);
S_k_w = sum(k_i .* w_i);
k_err = 1 ./ sqrt(S_w);

k = S_k_w ./ S_w;

k_med = mean(k_i);
k_err_med = std(k_i)/sqrt(N);

chi2 = sum(((k_i - k) ./ k_err_i).^2);
chi2_med = sum(((k_i - k_med) ./ k_err_i).^2);

hold on; grid on;
k_graph = yline(k, 'r', LineWidth=2.5); % media pesata
k_med_graph = yline(k_med, 'g', LineWidth=2.5); % media semplice
errorbar(P, k_i, k_err_i, 'xb', LineWidth=2, MarkerSize=10);

labelsize = 40;
xlabel('P [N]', FontSize=labelsize, Interpreter='latex');
ylabel('k [N/m]', FontSize=labelsize, Interpreter='latex');


legend( ...
    [k_graph, k_med_graph], ...
    { ...
        sprintf('Media Pesata (%.2f N/m)', k), ...
        sprintf('Media Semplice (%.2f N/m)', k_med) ...
    }, ...
    Location="northeast", ...
    FontSize=30 ...
    );

set(gca, "FontSize", 25);
hold off;

% --- CONFRONTO DIRETTO DEI CHI QUADRO NELLO SPAZIO DELLE LUNGHEZZE (h) ---

% 1. Dati grezzi per il confronto (come usati nel fit lineare originale)
h_raw = -dati(:, 4) ./ 100;
P_tutti = m .* g;
h_err_singolo = h_ris / sqrt(12); % Errore puro del righello, senza sqrt(2)

% 2. Previsione del modello FIT LINEARE
h_prev_fit = a_k + b_k .* P_tutti;

% 3. Previsione del modello MEDIA PESATA
% La media pesata prevede che l'allungamento sia (P - P0)/k rispetto a h0
h_prev_mean = zeros(size(h_raw));
h_prev_mean(1) = h_raw(1); % Il primo punto è il nostro h0 di riferimento
h_prev_mean(2:end) = h_raw(1) + (P_tutti(2:end) - P_tutti(1)) ./ k;

% 4. Calcolo dei due Chi Quadro omogenei
% Entrambi usano h_raw e h_err_singolo
chi2_confronto_fit = sum( ((h_raw - h_prev_fit) ./ h_err_singolo).^2 );
chi2_confronto_mean = sum( ((h_raw - h_prev_mean) ./ h_err_singolo).^2 );

% 5. Gradi di libertà (DOF)
DOF_fit = N - 2;  % Il fit ha bloccato 2 parametri (a, b)
DOF_mean = N - 1; % La media ha bloccato 1 parametro (k)

fprintf('\n--- CONFRONTO OMOGENEO NELLO SPAZIO DELLE LUNGHEZZE ---\n');
fprintf('Chi2 Fit Lineare:  %.2f (DOF = %d) -> Ridotto: %.5f\n', chi2_confronto_fit, DOF_fit, chi2_confronto_fit / DOF_fit);
fprintf('Chi2 Media Pesata: %.2f (DOF = %d) -> Ridotto: %.5f\n', chi2_confronto_mean, DOF_mean, chi2_confronto_mean / DOF_mean);