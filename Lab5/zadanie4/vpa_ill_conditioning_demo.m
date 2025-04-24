function [matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = ...
        vpa_ill_conditioning_demo()
% Określa wpływ współczynnika uwarunkowania macierzy Vandermonde'a na dokładność interpolacji.
% Generuje trzy wykresy ilustrujące uwarunkowanie macierzy i błędy interpolacji.
% W obliczeniach stosuje arytmetykę zmiennoprzecinkową o wyższej precyzji.

    a = vpa(-1);
    b = vpa(1);

    % Ustawienie domyślnej liczby cyfr zmiennych vpa
    digits(50);

    % Inicjalizacja danych
    matrix_sizes = 4:48:100;
    num_points = length(matrix_sizes);

    % Prealokacja danych wynikowych (pozostają typu double – bez vpa)
    condition_numbers = zeros(1, num_points);
    interpolation_error_exact = zeros(1, num_points);
    interpolation_error_perturbed = zeros(1, num_points);

    %===========================================================================
    % Część 1: Obliczanie współczynnika uwarunkowania macierzy Vandermonde'a
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        indices = vpa(0:size_n-1)';
        interpolation_nodes = a + indices * (b - a) / vpa(size_n - 1);

        V = get_vandermonde_matrix(interpolation_nodes);

        condition_numbers(index) = double(cond(V));
    end

    % Szukam progu złego uwarunkowania
    threshold_index = find(condition_numbers >= 1e8, 1);

    % Wykres 1
    tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    nexttile;
    semilogy(matrix_sizes, condition_numbers, 'LineWidth', 1.2);
    xlabel('Rozmiar macierzy N');
    ylabel('cond(V)');
    title('Współczynnik uwarunkowania V');
    grid on;

    if ~isempty(threshold_index)
        size_threshold = matrix_sizes(threshold_index);
        xline(size_threshold, ':', 'cond(V) > 10^8', 'LabelOrientation',...
            'horizontal', 'LabelVerticalAlignment', 'top',...
            'LabelHorizontalAlignment', 'left', 'LineWidth', 2, ...
            'Color', [0.494 0.184 0.556]);
    end

    %===========================================================================
    % Część 2: Obliczenie błędu interpolacji dla dokładnych danych (f(x)=x^2)
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        indices = vpa(0:size_n-1)';
        interpolation_nodes = a + indices * (b - a) / vpa(size_n - 1);

        V = get_vandermonde_matrix(interpolation_nodes);

        a2 = vpa(1);
        b_exact = a2 * interpolation_nodes.^vpa(2);
        reference_coefficients = [vpa(0); vpa(0); a2; vpa(zeros(size_n-3, 1))];

        computed_coefficients = V \ b_exact;

        interpolation_error_exact(index) = ...
            double(max(abs(computed_coefficients - reference_coefficients)));
    end

    % Wykres 2
    nexttile;
    plot(matrix_sizes, interpolation_error_exact, 'LineWidth', 1.2);
    xlabel('Rozmiar macierzy N');
    ylabel('Błąd max |a - a_{ref}|');
    title('Błąd współczynników (dokładne dane)');
    grid on;

    %===========================================================================
    % Część 3: Obliczenie błędu interpolacji dla danych zaburzonych
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        size_n_vpa = vpa(size_n);
        interpolation_nodes = a + (0:size_n_vpa-1)' * (b - a) / (size_n_vpa - 1);

        V = get_vandermonde_matrix(interpolation_nodes);

        a2 = vpa(1);
        noise = vpa(rand(size_n, 1) * 1e-9);
        b_perturbed = a2 * interpolation_nodes.^vpa(2) + noise;

        reference_coefficients = [vpa(0); vpa(0); a2; vpa(zeros(size_n - 3, 1))];
        computed_coefficients = V \ b_perturbed;

        interpolation_error_perturbed(index) = ...
            double(max(abs(computed_coefficients - reference_coefficients)));
    end

    % Wykres 3
    nexttile;
    semilogy(matrix_sizes, interpolation_error_perturbed, 'LineWidth', 1.2);
    xlabel('Rozmiar macierzy N');
    ylabel('Błąd max |a - a_{ref}|');
    title('Błąd współczynników (dane zaburzone)');
    grid on;
    saveas(gcf, 'zadanie4.png');
end

function V = get_vandermonde_matrix(x)
    % Buduje macierz Vandermonde’a na podstawie wektora węzłów interpolacji x.
    N = length(x);
    V = vpa(zeros(N));
    for i = 1:N
        V(:, i) = x.^(i-1);
    end
end
