function [min_cond] = intercond(inf_A, sup_A)
    m = size(inf_A, 1);
    n = size(inf_A, 2);
    if size(sup_A, 1) ~= m
        error('Количество строк inf_A и sup_A должно совпадать');
    end
    if size(sup_A, 2) ~= n
        error('Количество столбцов inf_A и sup_A должно совпадать');
    end
    
    for i = 1:m
        for j = 1:n
            if inf_A(i, j) > sup_A(i, j)
                error('Матрица sup_A поэлементно должна быть не меньше inf_A');
            end
        end
    end
    
    min_cond = Inf;
    num_of_tests = 20;
    for k = 1:num_of_tests
        M1 = ones(m, n);
        M2 = ones(m, n);
        epm = randi([0,1], m, n);
        for i = 1:m
            for j = 1:n
                if epm(i, j) == 0
                    M1(i, j) = inf_A(i, j);
                    M2(i, j) = sup_A(i, j);
                else
                    M1(i, j) = sup_A(i, j);
                    M2(i, j) = inf_A(i, j);
                end
            end
        end
        c1 = cond(M1, 2);
        c2 = cond(M2, 2);
        if min_cond > c1
            min_cond = c1;
        end
        if min_cond > c2
            min_cond = c2;
        end
    end
end