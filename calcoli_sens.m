data = readtable("dati_sensibilita.csv");

P = data.massa ./ 1000 .* g;
V = data.voltaggi;

P_mean = mean(P, 1);
V_mean = mean(V, 1);

var_P = var(P, 1);
covar = cov(P, V, 1);

b = covar(1,2) / var_P;
a = V_mean - b * P_mean;

R2 = 1 - sum((V - a - b .* P) .^ 2) / sum((V - V_mean) .^ 2);

P_space = linspace(0, 2, 20);

hold on; grid on;
plot(P_space, a + b .* P_space, 'r', 'LineWidth', 1);
plot(P, V, 'kx', 'MarkerSize', 15, 'LineWidth', 2);
hold off;