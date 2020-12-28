A_inf = readmatrix('data\A_inf.txt');
A_sup = readmatrix('data\A_sup.txt');
b_inf = readmatrix('data\b_inf.txt');
b_sup = readmatrix('data\b_sup.txt');
A(:, :, 1) = A_inf;
A(:, :, 2) = A_sup;
b = zeros(size(A,1), 2);
b(:, 1) = b_inf;
b(:, 2) = b_sup;

tau_values = 0.5:0.05:1.0;
n = length(tau_values);
ni_values = zeros(1, n);

for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);
hold on;

A(7, 7, 1) = 10;
for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);

A(7, 7, 1) = 12;
for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);
legend('$\underline{A}_{77} = 6$', '$\underline{A}_{77} = 10$', '$\underline{A}_{77} = 12$', 'interpreter','latex');