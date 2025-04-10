function [A, b] = generateMatrix(N, c1, c2, c3)
    % Generate the matrix A with tridiagonal pattern
    A = zeros(N, N);
    for i = 1:N
        for j = 1:N
            if i == j
                A(i, j) = c1;
            elseif i == j - 1
                A(i, j) = c2;
            elseif i == j + 1
                A(i, j) = c3;
            end
        end
    end

    % Generate the vector b
    b = zeros(N, 1);
    for i = 1:N
        b(i) = sin((i - 1) * 8);  % i-1 to match Python's 0-based indexing
    end
end
