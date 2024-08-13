import Base: show, +, -
import Plots.plot

struct Polinomio{T<:Number}
    coef::Vector{T}
end

Polinomio(v...) = Polinomio([v...])
coeficientes(p::Polinomio) = p.coef
grado(p::Polinomio) = length(coeficientes(p))

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

function _completar(v,w)
    if length(v)>length(w)
        a = v
        b = copy(w)
    elseif length(v)<length(w)
        a = w
        b = copy(v)
    else 
        a = v
        b = w
    end
    for i in 1:length(a)-length(b)
        push!(b,0)
    end
    return a,b
end

function +(p::Polinomio,q::Polinomio)
    c1,c2 = _completar(coeficientes(p),coeficientes(q))
    Polinomio(c1.+c2)
end

-(p::Polinomio) = Polinomio(-coeficientes(p))
-(p::Polinomio,q::Polinomio) = p + (-q)

(p::Polinomio)(x) = _eval(p,x)


plot(x,p::Polinomio) = plot(x,p.(x))
plot(p::Polinomio) = plot(-5:0.01:5,p)
