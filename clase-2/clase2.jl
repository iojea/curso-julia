function fibonacci(n)
    isinteger(n) || error("$n no es entero")
    fib = zeros(Int,n)
    fib[1:2] .= 1
    for i ∈ 3:n
        fib[i] = fib[i-1] + fib[i-2]
    end
    fib
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