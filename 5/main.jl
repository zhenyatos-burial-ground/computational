using ModalIntervalArithmetic

include("sub_diff.jl")

A = [ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1)
     ModalInterval(0.9, 1.1) ModalInterval(0.9, 1.1) ModalInterval(0.0, 0.0)
     ModalInterval(0.9, 1.1) ModalInterval(0.0, 0.0) ModalInterval(0.0, 0.0)]
b = [ModalInterval(2.8, 3.2), ModalInterval(1.8, 2.2), ModalInterval(0.9, 1.1)]

function main()
    x0 = init_point(A, b)
    println("x0    = ", sti_inv(x0))
    (x, count) = sub_diff(A, b, x0, 0.001)
    println("x     = ", x)
    println("count = ", count)
end

main()
