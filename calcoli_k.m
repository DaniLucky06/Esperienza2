data = readtable("dati_sensibilita.csv");

H = -data.altezza;
P = data.massa ./ 1000 .* g;

H_mean = mean(H, 1);
P_mean = mean(P, 1);

var_H = var(H, 1);
covar = cov(H, P, 1);

k = covar(1,2) / var_H;
q = P_mean - k * H_mean;

R2 = 1 - sum((P - q - k .* H) .^ 2) / sum((P - P_mean) .^ 2);

H_space = linspace(-20, -11, 20);

hold on; grid on;
plot(H_space, q + k .* H_space, 'r', 'LineWidth', 1);
plot(H, P, 'kx', 'MarkerSize', 15, 'LineWidth', 2);
hold off;