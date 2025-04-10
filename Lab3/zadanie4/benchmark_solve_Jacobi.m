function [A,b,x,vec_loop_times,vec_iteration_count] =...
        benchmark_solve_Jacobi(vN)
% Pomiar wydajności metody Jacobiego dla length(vN) równań macierzowych,
% przy czym liczba zmiennych i-tego równania wynosi vN(i).
% A - tablica komórkowa zawierająca zestaw macierzy A do równania macierzowego
%       A{i}*x{i}=b{i}, gdzie size(A{i},1) = vN(i)
% b - tablica komórkowa prawych stron równań A{i}*x{i}=b{i}
% x - tablica komórkowa z rozwiązaniami równań A{i}*x{i}=b{i}
% vec_loop_times(i) - czas wyznaczenia i-tego rozwiązania metodą Jacobiego
% vec_iterations_count(i) - liczba iteracji wykonana przy wyznaczeniu
%       i-tego rozwiązania metodą Jacobiego


vec_loop_times = zeros(1,length(vN));
vec_iteration_count = zeros(1,length(vN));

for i=1:length(vN)
    N = vN(i);

    [A{i},b{i}] = generate_matrix(N);
    x{i} = ones(N,1);

    L = tril(A{i},-1);
    U = triu(A{i},1);
    a = diag(A{i});
    D = diag(a,0);
    M = -D \ (L+U);
    w = D \ b{i};

    iteration_count = 0;
    inorm = 1e22;
    tic
    while(inorm>1e-12 && iteration_count<1000)
        x{i} = M*x{i} + w;
        inorm = norm(A{i}*x{i}-b{i});
        iteration_count = iteration_count+1;
    end
    vec_loop_times(i) = toc;
    vec_iteration_count(i) = iteration_count;
end

subplot(2,1,1);
plot(vN, vec_loop_times, '-o');
xlabel('Matrix size A (N)');
ylabel('Solve time [s]');
title('Jacobiego method solve time');

subplot(2,1,2);
plot(vN, vec_iteration_count, '-o');
xlabel('Matrix size A (N)');
ylabel('Iteration count');
title('Solve iteration count');

print("zadanie4.png",'-dpng')

end