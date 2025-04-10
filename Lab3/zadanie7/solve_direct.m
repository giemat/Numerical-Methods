function [x, r_norm] = solve_direct(A, b)
% Rozwiązanie równania A*x = b metodą bezpośrednią
% x - rozwiązanie
% r_norm - norma residuum ||Ax - b||
% t_direct - czas całkowity rozwiązania

x = A \ b;
r_norm = norm(A*x - b);
end
