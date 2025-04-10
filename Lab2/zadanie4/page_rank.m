function [Edges, I, B, A, b, r] = page_rank()
%indeks = 197714
Edges = [1,1,2,2,2,3,3,3,4,4,5,5,6,6,7;
    4,6,3,4,5,5,6,7,5,6,4,6,4,7,6];
N = 7;
I = speye(N);
B = sparse(Edges(2,:), Edges(1,:), 1, N, N);
L = sum(B,1)';

A = spdiags(1./L,0,N,N);

d = 0.85;
b = ((1 - d) / N) * ones(N, 1);
r = (I - d * B * A) \ b;
 figure;
    bar(r);
    title('PageRank for wab pages');
    xlabel('Page number');
    ylabel('PageRank Value');

end