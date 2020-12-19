using ModalIntervalArithmetic
using Plots

include("sub_diff.jl")

A = [ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1)
     ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1) ModalInterval(0.0, 0.0)
     ModalInterval(0.9, 1.1) ModalInterval(0.0, 0.0) ModalInterval(0.0, 0.0)]
b = [ModalInterval(2.8, 3.2), ModalInterval(2.2, 1.8), ModalInterval(0.9, 1.1)]

function main()
    x0 = init_point(A, b)
    println("x0    = ", x0)
    (x, count) = sub_diff(A, b, x0, 1.e-3)
    println("x     = ", x)
    println("count = ", count)

    n = 8
    iters = []
    for k = 1:n
        prec = 10.0^-k
        (x, count) = sub_diff(A, b, x0, prec)
        push!(iters, count)
    end
    plot(1:n, iters,
        xlabel = "-lg(ε)",
        ylabel = "Iterations number",
        xticks = [0:1:n;],
        yticks = [0:2:max(count);],
        dpi=300,
        legend = false)
    savefig("plot.png")
end

main()
