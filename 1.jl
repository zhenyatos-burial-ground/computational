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
detA = A[1, 1] * A[2, 2] - A[1, 2] * A[2, 1]
println("Determinant value: ", detA)
println("Determinant estimation criteria: ", 0 ∈ detA)

println("\nProblem 2")

# Matrix
A = Array{Interval{Float64}, 2}(undef, n, n)
for i = 1:n
    for j = 1:n
        if i == j
            A[i, j] = 1
        else
            A[i, j] = interval(0.0, ε)
        end
    end
end

# Beck 1
M = Array{Float64, 2}(undef, n, n)
R = Array{Float64, 2}(undef, n, n)
for i = 1:n
    for j = 1:n
        M[i, j] = mid(A[i, j])
        R[i, j] = radius(A[i, j])
    end
end

M1 = inv(M)
for i = 1:n
    for j = 1:n
        M1[i, j] = abs(M1[i, j])
    end
end
F = M1 * R

λ = eigvals(F)
m = size(λ, 1)
ρ = abs(λ[m])
res = ""
if ρ < 1
    res = "false"
else
    res = "unknown"
end
println("P = ", ρ)
println("Beck criteria: ", res)

# Beck 2
F = R * M1
diagMax = F[1, 1]
for i = 2:n
    if (diagMax < F[i, i])
        global diagMax = F[i, i]
    end
end

if (diagMax >= 1)
    res = "true"
else
    res = "unknown"
end
println("M = ", diagMax)
println("Diagonal criteria: ", res)
