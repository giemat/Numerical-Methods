function [coef_double, coef_vpa, y_double, y_vpa, y_mix] = ...
        interpolation_precision_comparison()
% Ilustruje wpływ precyzji obliczeń na interpolację wielomianową funkcji Rungego.

    f = @(x) 1 ./ (1 + 25 * x.^2); % funkcja Rungego

    % Liczba węzłów interpolacji
    n = 80;
    x_nodes = linspace(-1, 1, n);
    y_nodes = f(x_nodes).';

    x_fine = linspace(-1, 1, 1000);

    %---------------------------
    % Interpolacja double
    %---------------------------
    V_double = get_vandermonde_matrix(x_nodes);
    coef_double = V_double \ y_nodes;
    coef_double = coef_double(end:-1:1);  % Odwrócenie kolejności dla polyval
    y_double = polyval(coef_double, x_fine);

    %---------------------------
    % Interpolacja vpa
    %---------------------------
    digits(50);
    f_vpa = @(x) vpa(1) ./ (vpa(1) + vpa(25) * x.^2);
    x_nodes_vpa = linspace(-1, vpa(1), vpa(n));
    y_nodes_vpa = f_vpa(x_nodes_vpa).';

    V_vpa = get_vandermonde_matrix_vpa(x_nodes_vpa);
    coef_vpa = V_vpa \ y_nodes_vpa;
    coef_vpa = coef_vpa(end:-1:1);  % do Hornera

    y_vpa = polyval_vpa(coef_vpa, vpa(x_fine));

    %---------------------------
    % Interpolacja mieszana: vpa -> double
    %---------------------------
    coef_vpa_to_double = double(coef_vpa);
    y_mix = polyval(coef_vpa_to_double, x_fine);

%---------------------------
% Wykresy
%---------------------------
figure;

subplot(3,1,1);
plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
hold on
plot(x_fine, y_double, 'b', 'DisplayName', 'Interpolacja double');
title('Interpolacja z użyciem zmiennych double');
xlabel('x');
ylabel('y');
axis([-1 1 -2 2]); grid on; 
legend;

subplot(3,1,2);
plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
hold on
plot(x_fine, double(y_vpa), 'r', 'DisplayName', 'Interpolacja vpa');
title('Interpolacja z użyciem zmiennych vpa (50 cyfr)');
xlabel('x');
ylabel('y');
axis([-1 1 -2 2]); grid on; 
legend;

subplot(3,1,3);
plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
hold on
plot(x_fine, y_mix, 'm', 'DisplayName', 'Interpolacja vpa → double');
title('Interpolacja vpa → double (mieszana)');
xlabel('x');
ylabel('y');
axis([-1 1 -2 2]); grid on; 
legend;
saveas(gcf,"zadanie5.png");
end

% --- Pozostałe funkcje pomocnicze ---

function y = polyval_vpa(coefficients, x)
    n = length(coefficients);
    y = vpa(zeros(size(x)));
    for i = 1:n
        y = y .* x + coefficients(i);  % Horner
    end
end

function V = get_vandermonde_matrix(x)
    n = length(x);
    V = zeros(n);
    for i = 1:n
        V(:, i) = x.^(i-1);
    end
end

function V = get_vandermonde_matrix_vpa(x)
    n = length(x);
    V = vpa(zeros(n));
    for i = 1:n
        V(:, i) = x.^(i-1);
    end
end

function nodes = get_chebyshev_nodes(n)
    % Węzły Czebyszewa (double)
    k = 0:n-1;
    nodes = cos((2*k + 1) * pi / (2*n));
    nodes = nodes(end:-1:1);  % rosnąco
end

function nodes = get_chebyshev_nodes_vpa(n)
    % Węzły Czebyszewa (vpa)
    k = vpa(0:n-1);
    nodes = cos((2*k + 1) * vpa(pi) / (2*vpa(n)));
    nodes = nodes(end:-1:1);  % rosnąco
end
