using BenchmarkTools
"""
   estimate_pi(n) 
   
estima el valor de π mediante un argumento de Montecarlo: tira puntos al azar en el cuadrado [-1,1]² y calcula cuántos puntos caen en el círculo unitario.
"""
function estimate_pi(n)
    n = 0
    for i in 1:N
        x = 2*rand() - 1
        y = 2*rand() - 1
        if x^2 + y^2 <= 1
           n += 1
        end
    end
    return 4*n/N
end

function estimate_pi_vec(N)
    xy = 2*rand(N,2) .- 1
    norma = sum(xy.^2,dims=2)    
    en_circ = norma .≤ 1 
    n = sum(en_circ)
    return 4*n/N
end
