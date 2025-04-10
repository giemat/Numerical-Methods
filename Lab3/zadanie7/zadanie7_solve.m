close all;
clear all;

%load filtr_dielektryczny.mat
[A,b] = generateMatrix(1214,3,-1,-1);

[x_dir, r_dir] = solve_direct(A, b);
%[x_jacobi, r_jacobi] = solve_Jacobi(A, b);
%[x_gs, r_gs] = solve_Gauss_Seidel(A, b);

fprintf("Norma residuum (metoda bezpośrednia):      %.3e\n", r_dir);
%fprintf("Norma residuum (metoda Jacobiego):        %.3e\n", r_jacobi(end));
%fprintf("Norma residuum (metoda Gaussa-Seidla):    %.3e\n", r_gs(end));
