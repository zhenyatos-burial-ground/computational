% Функция написана на основе http://www.nsc.ru/interval/Programing/SciCodes/subdiff.sci
function [x, ni] = subdiff(A, b, tau, flag_print)

IterLim = 1000; 
Eps = 1.e-7;     

Dim = size(A, 1);
if Dim ~= size(A,2)
    error('Матрица системы должна быть квадратной!')
end
  
if size(A,3) ~= 2 
    error('Некорректно задана интервальность в матрице системы!')
end
  
if size(b,1)~= Dim 
    error('Размеры правой части не соответствуют размерам матрицы!')
end 
   
if size(b,2) ~= 2 
    error('Некорректно задана интервальность в правой части системы!')
end
   
if Eps < 0
    error('Некорректное задание невязки Eps!') 
end
  
if tau <= 0 || tau > 1
    error('Некорректно задан релаксационный параметр tau!') 
end
   
F = zeros(2*Dim);
d = zeros(2*Dim,1);
xx = zeros(2*Dim,1);
  
for i = 1:Dim
    for j = 1:Dim  
        p = 0.5*(A(i,j,1) + A(i,j,2));
        if( p >= 0. )
            F(i,j)=p; F(i+Dim,j+Dim)=p;
        else
            F(i+Dim,j)=p; F(i,j+Dim)=p; 
        end
    end
end
  
for i = 1:Dim
    xx(i) = b(i,1);    xx(i+Dim) = b(i,2); 
    d(2*i-1) = xx(i);  d(2*i) = xx(i+Dim); 
end
  
xx = F\xx;

ni = 0;   r = Inf;   q = 1;

while ( r/q>Eps && ni<IterLim )
    r = 0;      
    ni = ni+1; 
    x = xx;
    F = zeros(2 * Dim);
    for i = 1:Dim 
        s0 = 0;   s1 = 0;
        for j = 1:Dim 
            g0 = A(i,j,1);  g1 = A(i,j,2);
            h0 = x(j);      h1 = x(j+Dim); 
            if ( g0*g1>0 ) 
                if( g0>0 ), l=0; else l=2; end 
            else
                if( g0<=g1 ), l=1; else l=3; end
            end
            if ( h0*h1>0 ) 
                if( h0>0 ), m=1; else m=3; end
            else
                if( h0<=h1 ), m=2; else m=4; end
            end 
            switch ( 4*l+m ) 
                case 1
                    t0=g0*h0; t1=g1*h1; F(i,j)=g0; F(i+Dim,j+Dim)=g1; 
                case 2
                    t0=g1*h0; t1=g1*h1; F(i,j)=g1; F(i+Dim,j+Dim)=g1; 
                case 3
                    t0=g1*h0; t1=g0*h1; F(i,j)=g1; F(i+Dim,j+Dim)=g0;
                case 4
                    t0=g0*h0; t1=g0*h1; F(i,j)=g0; F(i+Dim,j+Dim)=g0;
                case 5
                    t0=g0*h1; t1=g1*h1; F(i,j+Dim)=g0; F(i+Dim,j+Dim)=g1;
                case 6
                    u0=g0*h1; v0=g1*h0;  u1=g0*h0; v1=g1*h1;
                    if u0<v0  
                        t0=u0; F(i,j+Dim)=g0; 
                    else
                        t0=v0; F(i,j)=g1;
                    end
                    if u1>v1 
                        t1=u1; F(i+Dim,j)=g0; 
                    else
                        t1=v1; F(i+Dim,j+Dim)=g1;
                    end
                case 7
                    t0=g1*h0; t1=g0*h0; F(i,j)=g1; F(i+Dim,j)=g0;
                case 8
                    t0=0; t1=0;
                case 9
                    t0=g0*h1; t1=g1*h0; F(i,j+Dim)=g0; F(i+Dim,j)=g1;
                case 10
                    t0=g0*h1; t1=g0*h0; F(i,j+Dim)=g0; F(i+Dim,j)=g0;
                case 11
                    t0=g1*h1; t1=g0*h0; F(i,j+Dim)=g1; F(i+Dim,j)=g0;
                case 12
                    t0=g1*h1; t1=g1*h0; F(i,j+Dim)=g1; F(i+Dim,j)=g1;
                case 13
                    t0=g0*h0; t1=g1*h0; F(i,j)=g0; F(i+Dim,j)=g1;
                case 14
                    t0=0; t1=0;
                case 15
                    t0=g1*h1; t1=g0*h1; F(i,j+Dim)=g1; F(i+Dim,j+Dim)=g0;
                case 16
                    u0=g0*h0; v0=g1*h1;  u1=g0*h1; v1=g1*h0;
                    if u0>v0 
                        t0=u0; F(i,j)=g0; 
                    else
                        t0=v0; F(i,j+Dim)=g1;
                    end
                    if u1<v1 
                        t1=u1; F(i+Dim,j+Dim)=g0;
                    else
                        t1=v1; F(i+Dim,j)=g1;
                    end
            end  
            s0 = s0+t0;       s1 = s1+t1;
        end
        t0 = s0 - d(2*i-1);  t1 = s1 - d(2*i);
        xx(i) = t0;  xx(i+Dim) = t1;
        r = r + max(abs(t0),abs(t1));
    end
    xx = x - tau*(F\xx); 
    q = sum(abs(xx));
    if q <= 1.e-23  
        q = 1; 
    end
end

if flag_print
    if ni >= IterLim
        fprintf('\n       Возможно, алгоритм расходится:')
        fprintf('\n       выделенное количество итераций исчерпано!\n')
    end
 
    fprintf('\n Формальное решение интервальной системы уравнений:\n');
    for i = 1:Dim
        u0 = xx(i);  u1 = xx(i+Dim);
        if u0 <= u1 
            prop = '    ->';
        else
            prop = '    <-';
        end
        fprintf('\n%3d%5s%14f%s%14f%s%s',i,'.   [',u0,',',u1,' ]',prop);
    end
  
    fprintf('\n\n\r Количество итераций = %d',ni);
    fprintf('\n\r 1-норма невязки приближённого решения = %f \n',r);
end
end