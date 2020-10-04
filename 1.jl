using IntervalArithmetic
using LinearAlgebra

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
