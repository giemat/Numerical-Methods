function [A,b,U,T,w,x,r_norm,iteration_count] = solve_Gauss_Seidel()
% A - macierz z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% U - macierz trójkątna górna, która zawiera wszystkie elementy macierzy A powyżej głównej diagonalnej,
% T - macierz trójkątna dolna równa A-U
% w - wektor pomocniczy opisany w instrukcji do Laboratorium 3
%       – sprawdź wzór (7) w instrukcji, który definiuje w jako w_{GS}.
% x - rozwiązanie równania macierzowego
% r_norm - wektor norm residuum kolejnych przybliżeń rozwiązania; norm(A*x-b);
% iteration_count - liczba iteracji wymagana do wyznaczenia rozwiązania
%       metodą Gaussa-Seidla

N = 5000;

[A,b] = generate_matrix(N);

iteration_count = 0;

M = [];
w = [];
x = ones(N,1);
r_norm = [];

L = tril(A,-1);
U = triu(A,1);
a = diag(A);
D = diag(a,0);

T = (D+L);
M = -T \ U;
w = T \ b;
inorm = norm(A*x-b);
r_norm = inorm;
while(inorm>1e-12 && iteration_count<1000)
    x = M*x + w;
    inorm = norm(A*x-b);
    iteration_count = iteration_count+1;
    r_norm = [ r_norm, inorm ];
end
iteracje = 0:iteration_count;
semilogy(iteracje,r_norm);
xlabel('Iteration number');
ylabel('Norma residuum (||Ax - b||)');
title('Gaus-Seidel method convergence');
print("zadanie5.png",'-dpng')
end