run("calcoli_statica.m")

% parametri grafici
legend_size = 25;
marker_size = 15;
marker_line_width = 1;
plots_line_width = 1;


% --- GRAFICI K --- %
P_space = linspace(0, 2.5, 10);
y_space = linspace(0, .1, 10);
% - Grafico dx-mg - %
    figure;
    hold on; grid on;

    p = plot(P_space, b_k .* P_space, 'r', 'LineWidth', plots_line_width);
    plot(P, h - a_k, 'kx', 'MarkerSize', marker_size, 'LineWidth', marker_line_width);
    % errorbar(P, h - a, y_k_err, y_k_err)
    
    xlabel("Peso [N]");
    ylabel("\Deltay [m]");
    title("Fit k1");
    legend(p, '\Deltay = 1/k\cdotmg', 'Fontsize', legend_size);

    hold off;

% - Grafico mg-dx - %
    figure;
    hold on; grid on;
    
    p = plot(y_space, k .* y_space, 'r', 'LineWidth', plots_line_width);
    plot(h - a_k, P, 'kx', 'MarkerSize', marker_size, 'LineWidth', marker_line_width);
    % errorbar(h - a, P, 0, 0, y_k_err, y_k_err)
    
    xlabel("\Deltay [m]");
    ylabel("Peso [N]");
    title("Fit k2");
    legend(p, 'mg = k\cdot\Deltay', 'Fontsize', legend_size);

    hold off;

% --- GRAFICI SENSIBILITA --- %
P_space = linspace(0, 2, 10);
V_space = linspace(-0.3, 0, 10);
    
% - Grafico V-mg - %
    figure;
    hold on; grid on;

    p = plot(P_space, a_V + b_V .* P_space, 'r', 'LineWidth', plots_line_width);
    plot(P, V, 'kx', 'MarkerSize', marker_size, 'LineWidth', marker_line_width);
    % errorbar(P, V, P_err, P_err, V_err, V_err)
    
    xlabel("Peso [N]");
    ylabel("Tensione [V]");
    title("Fit V1");
    legend(p, '\DeltaV = a + b\cdotmg', 'Fontsize', legend_size);
    
    hold off;

% - Grafico mg-V - %
    figure;
    hold on; grid on;
    
    p = plot(V_space, (V_space - a_V) ./ b_V, 'r', 'LineWidth', plots_line_width);
    plot(V, P, 'kx', 'MarkerSize', marker_size, 'LineWidth', marker_line_width);
    % errorbar(V, P, V_err, V_err, P_err, P_err)
    
    xlabel("Tensione [V]");
    ylabel("Peso [N]");
    title("Fit V2");
    legend(p, 'mg = (\DeltaV - a) / b', 'Fontsize', legend_size);
    
    hold off;