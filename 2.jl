using IntervalArithmetic
using Plots

# Flags are TESTS ONLY
flag_print_work_list = false
flag_lead_est_plot = true
flag_print_opt_est = false
flag_opt_est_plot = false

N = 20

# TESTS ONLY variables
n = []
widthX = []
widthY = []

rosenbrock(X) = 100 * (X[1]^2 - X[2])^2 + (X[1] - 1)^2

rasstrigin(X) = X[1]^2 + X[2]^2 - cos(18 * X[1]) - cos(18 * X[2])

shaffer(X) = 0.5 + (sin(X[1]^2 + X[2]^2)^2 - 0.5) / (1 + 0.001  * (X[1]^2 + X[2]^2))^2

function globOpt(X, foo)
    Y = foo(X)
    step_count = 1
    lead_est = Y.lo
    R = copy(X)
    work_list = [Dict("Box" => X, "Est" => Y.lo)]

    while step_count <= N
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
        R = work_list[lead_ind]["Box"]

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

        # This code is TESTS ONLY
        if flag_print_opt_est
            println("step: ", step_count, ", Y: ", foo(R))
        end

        rec1 = Dict("Box" => D1, "Est" => Y1.lo)
        rec2 = Dict("Box" => D2, "Est" => Y2.lo)

        # This code is TESTS ONLY
        if flag_lead_est_plot || flag_opt_est_plot
            push!(n, step_count)
            if flag_lead_est_plot
                push!(widthX, 2 * sum(radius.(R)))
            end
            if flag_opt_est_plot
                push!(widthY, 2 * radius(foo(R)))
            end
        end

        deleteat!(work_list, lead_ind)

        push!(work_list, rec1)
        push!(work_list, rec2)
        step_count = step_count + 1
    end

    # This code is TESTS ONLY
    if flag_print_work_list
        for rec in work_list
            print("[ ")
            for cmp in rec["Box"]
                print(cmp, " ")
            end
            println("], ", rec["Est"])
        end
    end

    return (lead_est, R)
end

X = [@interval(-30, 30), @interval(-30, 30)]
println(globOpt(X, rosenbrock))

# This code is TESTS ONLY
if flag_lead_est_plot
    plot(n, widthX,
        xticks = ([0:2:20;]),
        yticks = ([0:15:120;]),
        xlabel = "k",
        ylabel = "WidX",
        legend = false)
    png("plot1")
end

# This code is TESTS ONLY
if flag_opt_est_plot
    plot(n, widthY,
        xticks = ([0:5:100;]),
        xlabel = "k",
        ylabel = "WidY",
        legend = false)
    png("plot2")
end

# This code is TESTS ONLY
if flag_opt_est_plot
    global widthY = []
    global n = []
    globOpt(X, rosenbrock)
    plot(n, widthY,
        xticks = ([0:5:100;]),
        xlabel = "k",
        ylabel = "WidY",
        legend = false)
    png("plot3")
end
