import Base: show, +, -
import Plots.plot

struct Polinomio{T<:Number}
    coef::Vector{T}
    function Polinomio(v)
        while v[end]==0 && length(v)>1
            pop!(v)
        end
        new{eltype(v)}(v)
    end
end

Polinomio(v...) = Polinomio([v...])
coeficientes(p::Polinomio) = p.coef
grado(p::Polinomio) = length(coeficientes(p))-1

function show(io::IO,mime::MIME"text/plain",p::Polinomio)
    c = coeficientes(p)
    print(c[1])
    @inbounds for i in 2:length(c)
        if i==2 && c[i]!=0
             print(" + ",c[i],"x")
        elseif c[i]!=0
             print(" + ",c[i],"x^",i-1)
        end
    end
end 

function _eval(p::Polinomio,x)
    c = coeficientes(p)
    s = 0
    for i in 1:length(c)
        s += c[i]*x^(i-1)
    end
    s
end


function +(p::Polinomio,q::Polinomio)
    corto,largo = grado(p)≤grado(q) ? p,q : q,p
    suma = zeros(length(largo))
    for i in eachindex(corto)
        suma[i] = corto[i] + largo[i]
    end
    for i in length(corto):length(largo)
        suma[i] = largo[i]
    end
end

-(p::Polinomio) = Polinomio(-coeficientes(p))
-(p::Polinomio,q::Polinomio) = p + (-q)

(p::Polinomio)(x) = _eval(p,x)

plot(x,p::Polinomio) = plot(x,p.(x))
plot(p::Polinomio) = plot(-5:0.01:5,p)