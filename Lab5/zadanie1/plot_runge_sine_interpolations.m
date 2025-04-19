function [node_counts, exact_runge, exact_sine, V, interpolated_runge, interpolated_sine] = ...
    plot_runge_sine_interpolations()
% Generuje dwa wykresy przedstawiające interpolacje funkcji Rungego oraz
% funkcji sinusoidalnej. Funkcja zwraca
% 1) trzy wektory wierszowe
% 2) trzy tablice komórkowe (cell arrays) o rozmiarze [1,4].
% node_counts - wektor zawierający liczby węzłów, dla których wyznaczana
%   była interpolacja wielomianowa
% exact_runge - wektor wierszowy wartości funkcji Runge wyznaczonych
%       w punktach x_fine = linspace(-1, 1, 1000);
% exact_sine - wektor wierszowy wartości funkcji sinusoidalnej wyznaczonych
%       w punktach x_fine = linspace(-1, 1, 1000);
% V{i}: macierz Vandermonde'a wyznaczona dla node_counts(i) węzłów interpolacji
% interpolated_runge{i}: wektor wierszowy wartości wielomianu interpolującego
%       funkcję Runge'go dla stopnia wielomianu równego node_counts(i)-1.
% interpolated_sine{i}: wektor wierszowy wartości wielomianu interpolującego
%       funkcję sinusoidalną dla stopnia wielomianu równego node_counts(i)-1.

% Oznaczonie TODO wskazuje linijki kodu wymagające zmian

    % Lista liczby węzłów interpolacyjnych do przetestowania
    node_counts = [3, 5, 9, 13];

    % Definicja funkcji Rungego
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    % Definicja funkcji sinusoidalnej
    sine_function = @(x) sin(2 * pi * x);

    % Gęsta siatka punktów do testowania interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Ilustracja wartości wzorcowych interpolowanych funkcji
    % Wartości funkcji Rungego w punktach testowych (wartości wzorcowe)
    exact_runge = runge_function(x_fine);
    % Wartości funkcji sinusoidalnej w punktach testowych (wartości wzorcowe)
    exact_sine = sine_function(x_fine);

    % Inicjalizacja komórek
    V = cell(1, length(node_counts));
    interpolated_runge = cell(1, length(node_counts));
    interpolated_sine = cell(1, length(node_counts));

    % Rysowanie wykresu dla funkcji Rungego
    subplot(2,1,1);
    plot(x_fine, exact_runge, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja Rungego');
    hold on;

    % Rysowanie wykresu dla funkcji sinusoidalnej
    subplot(2,1,2);
    plot(x_fine, exact_sine, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja sinusoidalna');
    hold on;

    for i = 1:length(node_counts)
        N = node_counts(i);
        % Węzły interpolacji
        x_nodes = linspace(-1, 1, N)';

        % Macierz Vandermonde'a
        V{i} = get_vandermonde_matrix(x_nodes);

        % --- Interpolacja funkcji Rungego ---
        y_runge = runge_function(x_nodes);
        coefficients_runge = V{i} \ y_runge;
        coefficients_runge = coefficients_runge(end:-1:1);  % dopasowanie do polyval
        interpolated_runge{i} = polyval(coefficients_runge, x_fine);

        % --- Interpolacja funkcji sinusoidalnej ---
        y_sine = sine_function(x_nodes);
        coefficients_sine = V{i} \ y_sine;
        coefficients_sine = coefficients_sine(end:-1:1);
        interpolated_sine{i} = polyval(coefficients_sine, x_fine);

        % Rysowanie wyników interpolacji
        subplot(2,1,1);
        plot(x_fine, interpolated_runge{i}, 'DisplayName', ['Interpolacja N = ' num2str(N)]);

        subplot(2,1,2);
        plot(x_fine, interpolated_sine{i}, 'DisplayName', ['Interpolacja N = ' num2str(N)]);
    end

    % Dodanie legend i etykiet
    subplot(2,1,1);
    title('Interpolacja funkcji Rungego');
    xlabel('x');
    ylabel('y');
    legend show;
    legend('Location', 'eastoutside');

    subplot(2,1,2);
    title('Interpolacja funkcji sinusoidalnej');
    xlabel('x');
    ylabel('y');
    legend show;
    legend('Location', 'eastoutside');

    % Zapis wykresu do pliku
    set(gcf, 'Position', [100 100 1200 800]);
    saveas(gcf, 'zadanie1.png');
end

function V = get_vandermonde_matrix(x)
    % Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x.
    N = length(x);
    V = zeros(N);
    for i = 1:N
        V(:, i) = x.^(i-1);
    end
end
