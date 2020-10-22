using IntervalArithmetic

rosenbrock(X) = 100 * (X[1]^2 - X[2])^2 + (X[1] - 1)^2

rasstrigin(X) = X[1]^2 + X[2]^2 - cos(18 * X[1]) - cos(18 * X[2])

function globOpt(X, foo)
    Y = foo(X)
    step_count = 1
    lead_est = Y.lo
    R = copy(X)
    work_list = [Dict("Box" => X, "Est" => Y.lo)]

    while step_count <= 100
        list_lenght = size(work_list)[1]
        lead_est = work_list[1]["Est"]
        lead_ind = 1
        for k = 1:list_lenght
            est = work_list[k]["Est"]
            if (est < lead_est)
                lead_est = est
                lead_ind = k
            end
        end
        R = copy(work_list[lead_ind]["Box"])

        D1 = copy(R)
        D2 = copy(D1)
        (rad_max, ind_max) = findmax(radius.(D1))

        s = D1[ind_max]
        sl = s.lo
        sh = s.hi
        sm = mid(s)
        D1[ind_max] = @interval(sl, sm)
        D2[ind_max] = @interval(sm, sh)

        Y1 = foo(D1)
        Y2 = foo(D2)

        rec1 = Dict("Box" => D1, "Est" => Y1.lo)
        rec2 = Dict("Box" => D2, "Est" => Y2.lo)

        deleteat!(work_list, lead_ind)

        push!(work_list, rec1)
        push!(work_list, rec2)

        step_count = step_count + 1
    end

    return (lead_est, R)
end

X = [@interval(1, 2), @interval(2, 3)]
println(globOpt(X, rosenbrock))
println(globOpt(X, rasstrigin))
