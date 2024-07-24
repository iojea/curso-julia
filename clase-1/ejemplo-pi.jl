using BenchmarkTools
"""
   estimate_pi(n) 
   
estima el valor de π mediante un argumento de Montecarlo: tira puntos al azar en el cuadrado [-1,1]² y calcula cuántos puntos caen en el círculo unitario.
"""
function estimate_pi(n)
    n_circle = 0
    for i in 1:n
        x = 2*rand() - 1
        y = 2*rand() - 1
        if sqrt(x^2 + y^2) <= 1
           n_circle += 1
        end
    end
    return 4*n_circle/n
end

function estimate_pi_vec(n)
    xy = 2*rand(n,2) .- 1
    n_circle = sum(sum(xy.^2,dims=2) .<= 1)
    return 4*n_circle/n
end
