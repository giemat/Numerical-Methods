function [xvec,xdif,xsolution,ysolution,iterations] = impedance_bisection()
% Wyznacza miejsce zerowe funkcji impedance_difference metodą bisekcji.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego, gdzie xvec(1)= (a+b)/2
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji impedance_difference wyznaczona dla f=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

a = 1; % lewa granica przedziału poszukiwań miejsca zerowego
b = 10; % prawa granica przedziału poszukiwań miejsca zerowego
ytolerance = 1e-12; % tolerancja wartości funkcji w przybliżonym miejscu zerowym.
% Warunek abs(f1(xsolution))<ytolerance określa jak blisko zera ma znaleźć
% się wartość funkcji w obliczonym miejscu zerowym funkcji f1(), aby obliczenia
% zostały zakończone.
max_iterations = 1000; % maksymalna liczba iteracji wykonana przez alg. bisekcji

fa = impedance_difference(a);
fb = impedance_difference(b);

xvec = [];
xdif = [];
xsolution = Inf;
ysolution = Inf;
iterations = max_iterations;

for ii=1:max_iterations
    c = (a+b)/2;
    xvec(ii,1) = c;
    fc = impedance_difference(c);
    if(abs(fc)<ytolerance)
        xdif(ii-1,1) = abs(xvec(ii)-xvec(ii-1));
        xsolution = c;
        ysolution = fc;
        iterations = ii;
        break
    else
         % Aktualizacja przedziału na podstawie zmiany znaku
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
        
        % Obliczenie różnicy między kolejnymi przybliżeniami, o ile to nie pierwsza iteracja
        if ii > 1
            xdif(ii-1,1) = abs(xvec(ii) - xvec(ii-1));
        end
        
        % Jeżeli osiągnięto maksymalną liczbę iteracji, przypisz aktualne wartości
        if ii == max_iterations
            warning('Osiągnięto maksymalną liczbę iteracji bez osiągnięcia zadanej dokładności.');
            xsolution = c;
            ysolution = fc;
            iterations = ii;
        end
    end
end
 % Wizualizacja wyników - wykresy:
    figure;
    
    % Wykres 1: Kolejne przybliżenia miejsca zerowego (skala liniowa)
    subplot(2,1,1);
    plot(1:length(xvec), xvec,'LineWidth',1.5);
    xlabel('Numer iteracji');
    ylabel('Przybliżenie x');
    title('Kolejne przybliżenia miejsca zerowego metodą bisekcji');
    
    % Wykres 2: Różnice kolejnych przybliżeń (skala logarytmiczna)
    subplot(2,1,2);
    semilogy(1:length(xdif), xdif,'LineWidth',1.5);
    xlabel('Numer iteracji');
    ylabel('|x_{n+1} - x_n|');
    title('Zmniejszanie się różnicy kolejnych przybliżeń');
    print("zadanie2.png",'-dpng')
end

function impedance_delta = impedance_difference (f)
% Wyznacza moduł impedancji równoległego obwodu rezonansowego RLC pomniejszoną o wartość M.
% f - częstotliwość
if(f<=0)
    error("f value below/equal to zero")
end
R = 525;
L = 3;
C = 7*10^(-5);
M = 75;
Z = 1 ./ sqrt( (1./R.^2) + ( (2*pi*f*C) - 1./(2*pi*f*L) ).^2 );

impedance_delta = 0;
impedance_delta = Z - M;

end