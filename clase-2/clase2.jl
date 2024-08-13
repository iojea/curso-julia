function fibonacci(n)
    isinteger(n) || error("$n no es entero")
    fib = zeros(Int,n)
    fib[1:2] .= 1
    for i ∈ 3:n
        fib[i] = fib[i-1] + fib[i-2]
    end
    fib
end
import Plots 
@inbounds for i in 1:2
end

function comparar(x,y)
    if x<y
        println("$x es menor que $y")
    elseif x>y
        println("$x es mayor que $y")
    else
        println("$x y $y son iguales")
    end
end      

plot(-1:0.1:1,t->t^2,color=:red)
# this is a comment
x::Float64 = 3




