run("calcoli_dinamica.m")

% parametri grafici
legend_size = 25;
marker_size = 15;
marker_line_width = 1;
plots_line_width = 1;


% --- GRAFICI K --- %
x_space = linspace(0, .25, 10);
y_space = linspace(0, .1, 10);
% - Grafico dx-mg - %
    figure;
    hold on; grid on;
    x = m;
    y = T2;

    p = plot(x_space, a + b .* x_space, 'r', 'LineWidth', plots_line_width);
    plot(x, y, 'kx', 'MarkerSize', marker_size, 'LineWidth', marker_line_width);
    errorbar(x, y, y_err_chi2, y_err_chi2)
    
    xlabel("Massa [kg]");
    ylabel("T^2 [s]");
    title("Fit");
    legend(p, 'T^2 = a + b\cdotm', 'Fontsize', legend_size);

    hold off;

% - Grafico errori - %
    figure;
    hold on; grid on;
    errorbar(x, y - (a + b .* x), y_err_chi2, 'k+');
    errorbar(x, y - (a + b .* x), y_err_i, 'kx');
    plot(x, zeros(length(x)), 'r')
    hold off;