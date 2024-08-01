using Plots

function euler(f,x₀,tspan,N)
    d = length(x₀)
    x = zeros(d,N)
    x[:,1] .= x₀
    t = range(start=tspan[1],stop=tspan[2],length=N)
    h = t[2]-t[1]
    @inbounds for i in 1:N-1
        x[:,i+1] = x[:,i] + h*f(x[:,i],t[i])
    end
    t,x
end
