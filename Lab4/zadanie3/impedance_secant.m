function [xvec,xdif,xsolution,ysolution,iterations] = impedance_secant()
% Wyznacza miejsce zerowe funkcji impedance_difference metodą siecznych.
% Dodatkowo rysuje wykresy:
%   - Zbieżność kolejnych przybliżeń (xvec)
%   - Różnice między kolejnymi przybliżeniami (xdif)
%
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego
%   (xvec(1) = x2 przy założeniu, że x0 i x1 są punktami startowymi)
% xdif - wektor różnic kolejnych przybliżeń
%   (xdif(i) = abs(xvec(i+1)-xvec(i)))
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji impedance_difference w punkcie xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

    %--- Parametry startowe i ustawienia metody siecznych ---
    x0 = 1;          % pierwszy punkt startowy
    x1 = 10;         % drugi punkt startowy
    ytolerance = 1e-12;  % tolerancja wartości funkcji w miejscu zerowym
    max_iterations = 1000; % maksymalna liczba iteracji

    %--- Obliczenie wartości funkcji w punktach startowych ---
    f0 = impedance_difference(x0);
    f1 = impedance_difference(x1);

    %--- Przygotowanie zmiennych wyjściowych ---
    xvec = [];       % wektor kolejnych przybliżeń
    xdif = [];       % wektor różnic między przybliżeniami
    xsolution = Inf; % ostateczne rozwiązanie
    ysolution = Inf; % wartość funkcji w rozwiązaniu
    iterations = max_iterations;

    % Pętla główna metody siecznych
    for ii = 1:max_iterations
        % Obliczenie kolejnego przybliżenia x2 metodą siecznych
        % x2 = x1 - f1*(x1 - x0) / (f1 - f0)
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
        f2 = impedance_difference(x2);
        
        % Zapis kolejnego przybliżenia
        xvec(ii,1) = x2;
        if ii > 1
            xdif(ii-1,1) = abs(x2 - xvec(ii-1));
        end
        
        % Sprawdzenie warunku zbieżności
        if abs(f2) < ytolerance
            xsolution = x2;
            ysolution = f2;
            iterations = ii;
            break;
        end
        
        % Aktualizacja punktów dla kolejnej iteracji
        x0 = x1;
        f0 = f1;
        x1 = x2;
        f1 = f2;
    end

    % Jeśli nie osiągnięto kryterium zbieżności, ustawiamy ostatnie wartości:
    if isinf(xsolution)
        xsolution = x2;
        ysolution = f2;
    end

    %--- Rysowanie wykresów zbieżności ---
    figure;
    % Wykres kolejnych przybliżeń (xvec)
    subplot(2,1,1);
    plot(1:length(xvec), xvec);
    grid on;
    xlabel('Numer iteracji');
    ylabel('Przybliżenie x');
    title('Zbieżność metody siecznych');

    % Wykres różnic kolejnych przybliżeń (xdif)
    subplot(2,1,2);
    semilogy(1:length(xdif), xdif); % wykres logarytmiczny, gdyż wartości szybko maleją
    grid on;
    xlabel('Numer iteracji');
    ylabel('Różnica |x_{i+1} - x_i|');
    title('Zmiana kolejnych przybliżeń');
    print("zadanie3.png",'-dpng');
end

function impedance_delta = impedance_difference(f)
% Wyznacza różnicę: (moduł impedancji równoległego obwodu RLC) - M
% f - częstotliwość
    if (f <= 0)
        error("f value must be > 0");
    end

    R = 525;
    L = 3;
    C = 7e-5;  % 7 * 10^(-5)
    M = 75;

    % Obliczenie modułu impedancji obwodu równoległego RLC
    Z = 1 ./ sqrt( (1./R.^2) + ( (2*pi*f*C) - 1./(2*pi*f*L) ).^2 );

    % Obliczenie różnicy względem M
    impedance_delta = Z - M;
end
