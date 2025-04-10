function [x, r_norm] = solve_Jacobi(A, b)
% x - przybliżone rozwiązanie A*x = b metodą Jacobiego
% r_norm - wektor norm residuum dla kolejnych iteracji

N = length(b);

x = ones(N,1);
iteration_count = 0;
r_norm = [];

L = tril(A,-1);
U = triu(A,1);
D = diag(diag(A));

M = -D \ (L + U);
w = D \ b;

inorm = norm(A*x - b);
r_norm(end+1) = inorm;

while inorm > 1e-12 && iteration_count < 750
    x = M * x + w;
    inorm = norm(A*x - b);
    iteration_count = iteration_count + 1;
    r_norm(end+1) = inorm;
end
end
