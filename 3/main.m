addpath("IntLinInc2D");
addpath("IntLinInc3D");

inf_A = [0.9 0.1; 
        0.7 0.1; 
        0.1 0.8];
 
sup_A = [1 0.2;
        0.9 0.2;
        0.1 1.1];
    
inf_b = [0.5; 1.0; 0.7];
sup_b = [1.6; 2.2; 1.3];

inf_c = [0.5; 0.6];
sup_c = [1.1; 1.2];
 
% Рисуем допусковое множество решений для 3 х 2
[V] = EqnTol2D(inf_A, sup_A, inf_b, sup_b);

% Вычисляем IVE 
[tolmax, argmax] = tolsolvty(inf_A, sup_A, inf_b, sup_b);
b = ppoint(inf_b, sup_b);
cond1 = intercond(inf_A, sup_A);
ive1 = sqrt(2) * tolmax * norm(argmax) / norm(b) * cond1;
disp("IVE_2D = " + ive1);
disp("max Tol = " + tolmax);
disp("||arg max Tol|| = " + norm(argmax));
disp("cond = " + cond1);
disp("||b|| = " + norm(b));
disp("---------------------");

% Вычисляем распознающий функционал
[X,Y] = meshgrid(1.2:0.01:1.6,0.6:0.01:1.2);
Z = zeros(size(X));
for i = 1:size(Z, 1)
    for j = 1:size(Z, 2)
        Z(i, j) = Tol(X(i, j), Y(i, j), inf_A, sup_A, inf_b, sup_b);
    end
end

% Рисуем его график
figure
hold on;
surf(X,Y,Z);
contour3(X,Y,Z,[0 0], 'r');
hold off;

% Рисуем 3-хмерный образ допускового множества для 2 х 3
[V] = EqnTol3D(inf_A', sup_A', inf_c, sup_c, 1, 1);
[tolmax, argmax] = tolsolvty(inf_A', sup_A', inf_c, sup_c);
c = ppoint(inf_c, sup_c);
cond2 = intercond(inf_A', sup_A');
ive2 = sqrt(3) * tolmax * norm(argmax) / norm(c) * cond2;
disp("IVE_3D = " + ive2);
disp("max Tol = " + tolmax);
disp("||arg max Tol|| = " + norm(argmax));
disp("cond = " + cond2);
disp("||c|| = " + norm(c));