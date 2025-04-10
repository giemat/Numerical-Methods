function [x, r_norm] = solve_Gauss_Seidel(A, b)
N = length(b);

x = ones(N,1);
iteration_count = 0;
r_norm = [];

L = tril(A, -1);
U = triu(A, 1);
D = diag(diag(A));

T = D + L;
M = -T \ U;
w = T \ b;

inorm = norm(A*x - b);
r_norm(end+1) = inorm;

while inorm > 1e-12 && iteration_count < 750
    x = M * x + w;
    inorm = norm(A*x - b);
    iteration_count = iteration_count + 1;
    r_norm(end+1) = inorm;
end
end
