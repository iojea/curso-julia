struct Polinomio{T} where T<:Number
    coef::Vector{T}
end

Polinomio(v...) = Polinomio([v...])
coeficientes(p::Polinomio) = p.coef
grado(p::Polinomio) = length(coeficientes(p))

function Base.show(io::IO,p::Polinomio)
    c = coeficientes(p)
    print(c[1])
    for i in 2:length(c)
        print(" + ",c[i],"x^$(i-1)")
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

function +(p::Pol,q::Pol)
    cp = coeficientes(p)
    cq = coeficientes(q)
    if length(cp)<length(cq)
        
    end
end

(p::Polinomio)(x) = _eval(p,x)
