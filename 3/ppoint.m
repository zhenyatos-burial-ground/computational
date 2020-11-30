function [x] = ppoint(inf_x, sup_x)
    x = 0.5 * (abs(sup_x) - abs(inf_x));
end