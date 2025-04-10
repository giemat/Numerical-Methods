function [index_number, Edges, I, B, A, b, r] = page_rank()
index_number = 197714;
Edges = [1,1,2,2,2,3,3,3,4,4,5,5,6,6,7;
    4,6,3,4,5,5,6,7,5,6,4,6,4,7,6];
N = 7;
L = mod(index_number,10);
A_index = 1 + mod(L,7);
new_edges = [1,6,7,4,3,1,1,7;5,5,5,2,2,2,3,2];
Edges = [Edges, new_edges];
I = speye(N);
B = sparse(Edges(2,:), Edges(1,:), 1, N, N);
L = sum(B,1)';

A = spdiags(1./L,0,N,N);

d = 0.85;
b = repelem((1-d)/N, N)';
M = I - d*B*A;
r = M\b;
 figure;
    bar(r);
    title('PageRank for wab pages');
    xlabel('Page number');
    ylabel('PageRank Value');
end