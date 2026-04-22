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
    ylabel("T^2 [s^2]");
    title("Fit");
    legend(p, 'T^2 = a + b\cdotm', 'Fontsize', legend_size);

    hold off;

% - Grafico errori - %
    figure;
    hold on; grid on;
    err_bar_chi2 = errorbar(x, y - (a + b .* x), y_err_chi2, 'gx', Marker='none', LineWidth=1);
    err_bar = errorbar(x, y - (a + b .* x), y_err_i, 'bx', MarkerSize=10, LineWidth=2);
    yline(0, 'r', LineWidth=2)

    set(gca, "FontSize", 25);
    legend( ...
        [err_bar(1), err_bar_chi2(1)], ...
        {'Errori base', 'Errori per chi corretto'}, ...
        Location="northeast", ...
        FontSize=30 ...
    );

    ax_font = 40;
    xlabel('Massa [kg]', 'FontSize', ax_font, 'Interpreter', 'latex');
    ylabel('$(T^2 - \bar{T}^2 )\, [s^2]$', 'FontSize', ax_font, 'Interpreter', 'latex');
    hold off;