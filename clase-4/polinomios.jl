import Base: show, +, -

struct Polinomio{T<:Number} <: Function
    coef::Vector{T}
    function Polinomio(v)
        while v[end]==0 && length(v)>1
            pop!(v)
        end
        new{eltype(v)}(v)
    end
end
Polinomio(x...) = Polinomio([x...])
Polinomio(t::Tuple) = Polinomio(t...)
Polinomio(x::Number) = Polinomio([x])

function show(io::IO,mime::MIME"text/plain",p::Polinomio)
    c = p.coef
    print(c[1])
    for i in 2:length(c)
        if c[i] != 0
            if i>2
                print(" + ",c[i],"x^",i-1)
            else
                print(" + ",c[i],"x")
            end
        end
    end
end

grado(p::Polinomio) = length(p.coef) -1
coeficientes(p::Polinomio) = p.coef
 
function +(p::Polinomio,q::Polinomio)
    c1,c2 = p.coef,q.coef
    corto,largo = length(c1)≤length(c2) ? (c1,c2) : (c2,c1)
    suma = zeros(length(largo))
    for i in 1:length(corto)
        suma[i] = corto[i] + largo[i]
    end
    for i in length(corto)+1:length(largo)
        suma[i] = largo[i]
    end
    Polinomio(suma)
end

-(p::Polinomio) = Polinomio(-p.coef)

-(p::Polinomio,q::Polinomio) = p + (-q)

function (p::Polinomio)(x)
    c = p.coef
    s = c[1]
    for i in 2:length(c)
        s = s + c[i]*x^(i-1)
    end
    s
end

