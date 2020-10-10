using IntervalArithmetic
using LinearAlgebra
using IterTools

function gen(n::Int)
    return Base.Iterators.product([0:1 for i in 1:n]...)
end

# Input processing
print("ε = ")
ε = parse(Float64, readline())
print("n = ")
n = parse(Int, readline())

println("\nProblem 1")

# Matrix
A = [interval(1-ε, 1+ε) interval(1-ε, 1+ε);
    interval(1.1-ε, 1.1+ε) interval(1-ε, 1+ε)]

# Determinant estimation
det_A = A[1, 1] * A[2, 2] - A[1, 2] * A[2, 1]
println("Determinant value: ", det_A)
println("Determinant estimation criteria: ", 0 ∈ det_A)

println("\nProblem 2")

# Matrix
A = Array{Interval{Float64}, 2}(undef, n, n)
for i = 1:n, j = 1:n
    A[i, j] = i == j ? 1 : interval(0.0, ε)
end

# Beck 1
M = [mid(A[i, j]) for i=1:n, j=1:n]
R = [radius(A[i, j]) for i=1:n, j=1:n]

M1 = [abs(inv(M)[i, j]) for i=1:n, j=1:n]
F = M1 * R

λ = eigvals(F)
m = size(λ, 1)
ρ = abs(λ[m])
println("P = ", ρ)
println("Beck criteria: ", ρ < 1 ? "false" : "unknown")

# Beck 2
F = R * M1
diag_max = F[1, 1]
for i = 2:n
    if (diag_max < F[i, i])
        global diag_max = F[i, i]
    end
end

println("M = ", diag_max)
println("Diagonal criteria: ", diag_max >= 1 ? "true" : "unknown")

# Baumans
list = gen(n^2)
A1 = zeros((n, n))
A2 = zeros((n, n))
res = false
counter = 0
next1 = iterate(list)
while next1 != nothing
    (elem1, state1) = next1
    for i = 1:n, j = 1:n
        A1[i, j] = (elem1[(i - 1) * n + j] == 0) ? A[i, j].hi : A[i, j].lo
    end
    next2 = iterate(list, state1)
    det_A1 = det(A1)
    while next2 != nothing
        (elem2, state2) = next2
        for i = 1:n, j = 1:n
            A2[i, j] = (elem2[(i - 1) * n + j] == 0) ? A[i, j].hi : A[i, j].lo
        end
        global counter = counter + 1
        if (det_A1 * det(A2) <= 0)
            global res = true
            break
        end
        next2 = iterate(list, state2)
    end

    if res
        break
    end
    global next1 = iterate(list, state1)
end
println("Baumans: ", res)
println("Test: ", counter)
