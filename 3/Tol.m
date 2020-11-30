function [z] = Tol(x, y, inf_A, sup_A, inf_b, sup_b)
    m = size(inf_A, 1);
    
    if ~isequal(size(inf_A), size(sup_A))
        error('Размерности inf_A и sup_A должны совпадать');
    end
    
    if size(inf_A, 2) ~= 2
        error('Количество столбцов матриц inf_A и sup_A должно равняться 2');
    end
    
    if ~isequal(size(inf_b), size(sup_b))
        error('Размерности inf_b и sup_b должны совпадать');
    end
    
    if size(inf_b, 2) ~= 1
        error('inf_b и sup_b должны быть вектор-столбцами');
    end
    
    z = Inf;
    for i = 1:m
        s1 = 0;
        s2 = 0;
        
        if (x >= 0)
            s1 = s1 + inf_A(i, 1) * x;
            s2 = s2 + sup_A(i, 1) * x;
        else
            s1 = s1 + sup_A(i, 1) * x;
            s2 = s2 + inf_A(i, 1) * x;
        end
        
        if (y >= 0)
            s1 = s1 + inf_A(i, 2) * y;
            s2 = s2 + sup_A(i, 2) * y;
        else
            s1 = s1 + sup_A(i, 2) * y;
            s2 = s2 + inf_A(i, 2) * y;
        end
       
        mid_b = 0.5 * (inf_b(i, 1) + sup_b(i, 1));
        
        temp = 0.5 * (sup_b(i, 1) - inf_b(i, 1)) - max(abs(mid_b - s1), abs(mid_b - s2));
        if (temp < z)
            z = temp;
        end
    end
end