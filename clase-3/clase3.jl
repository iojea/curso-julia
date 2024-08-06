function euler(f,x₀,tspan,N)
    t0,tf = tspan
    t     = range(t0,tf,length=N)
    h     = t[2]-t[1]
    d     = length(x₀)
    x     = zeros(d,N)
    x[:,1]  = x₀
    for n in 1:N-1
        x[:,n+1] = x[:,n] + h*f(x[:,n],t[n])
    end
    return t,x
end
