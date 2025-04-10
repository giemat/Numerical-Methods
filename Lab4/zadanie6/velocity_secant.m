function [xvec,xdif,xsolution,ysolution,iterations] = velocity_secant()
% Wyznacza miejsce zerowe funkcji velocity_difference metodą siecznych.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego;
%   xvec(1)=x2 przy założeniu, że x0 i x1 są punktami startowymi
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji velocity_difference wyznaczona dla f=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

%--- Parametry startowe i ustawienia metody siecznych ---
x0 = 1;          % pierwszy punkt startowy
x1 = 40;         % drugi punkt startowy
ytolerance = 1e-12;  % tolerancja wartości funkcji w miejscu zerowym
max_iterations = 1000; % maksymalna liczba iteracji

%--- Obliczenie wartości funkcji w punktach startowych ---
f0 = velocity_difference(x0);
f1 = velocity_difference(x1);

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
    f2 = velocity_difference(x2);
    
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
print("zadanie6.png",'-dpng');
end

function velocity_delta = velocity_difference(t)
% t - czas od startu rakiety

if(t<=0)
    error("Error:Time below zero");
end

m0 = 150000;
q = 2700;
u = 2000;
g = 1.622;
M = 700;

v = u .* log(m0 ./ (m0 - q .* t)) - g .* t;
velocity_delta = v - M;
end