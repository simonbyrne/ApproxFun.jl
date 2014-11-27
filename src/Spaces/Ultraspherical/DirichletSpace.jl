# DirichletSpaces


immutable ChebyshevDirichletSpace{left,right} <: IntervalDomainSpace
    domain::Union(IntervalDomain,AnyDomain)
    ChebyshevDirichletSpace(d)=new(d)
    ChebyshevDirichletSpace()=new(Interval())    
end

ChebyshevDirichletSpace()=ChebyshevDirichletSpace{1,1}()



canonicalspace(S::ChebyshevDirichletSpace)=ChebyshevSpace(domain(S))


## Dirichlet Conversion

addentries!(C::Conversion{ChebyshevDirichletSpace{1,0},ChebyshevSpace},A::ShiftArray,kr::Range1)=toeplitz_addentries!(ShiftVector([1.,1.],1),A,kr)
addentries!(C::Conversion{ChebyshevDirichletSpace{0,1},ChebyshevSpace},A::ShiftArray,kr::Range1)=toeplitz_addentries!(ShiftVector([1.,-1.],1),A,kr)
function addentries!(C::Conversion{ChebyshevDirichletSpace{1,1},ChebyshevSpace},A::ShiftArray,kr::Range)
    A=toeplitz_addentries!(ShiftVector([1.,0.,-1.],1),A,kr)    
    if kr[1]==1
        A[1,1]+=-1
    end
    A
end
function addentries!(C::Conversion{ChebyshevDirichletSpace{2,2},ChebyshevSpace},A::ShiftArray,kr::Range)
    for k=kr
        A[k,0]=1
        A[k,4]=2*(k+1)/k-1
        if k>= 3
            A[k,2]=-2*(k-1)/(k-2)
        end
    end
    
    A
end
bandinds(::Conversion{ChebyshevDirichletSpace{1,0},ChebyshevSpace})=0,1
bandinds(::Conversion{ChebyshevDirichletSpace{0,1},ChebyshevSpace})=0,1
bandinds(::Conversion{ChebyshevDirichletSpace{1,1},ChebyshevSpace})=0,2

conversion_rule(b::ChebyshevDirichletSpace,a::ChebyshevSpace)=b

# return the space that has banded Conversion to the other
# function conversion_rule(a::ChebyshevDirichletSpace,b::UltrasphericalSpace)
#     @assert domainscompatible(a,b)
#     
#     a
# end




## Evaluation Functional


function getindex(B::Evaluation{ChebyshevDirichletSpace{1,0},Bool},kr::Range)
    d = domain(B)
    
    if B.x == false && B.order == 0
        Float64[k==1?1.0:0.0 for k=kr]
    else
        getindex(Evaluation(d,B.x,B.order)*Conversion(domainspace(B)),kr)
    end
end

function getindex(B::Evaluation{ChebyshevDirichletSpace{0,1},Bool},kr::Range)
    d = domain(B)
    
    if B.x == true && B.order == 0
        Float64[k==1?1.0:0.0 for k=kr]
    else
        getindex(Evaluation(d,B.x,B.order)*Conversion(domainspace(B)),kr)
    end
end

function getindex(B::Evaluation{ChebyshevDirichletSpace{1,1},Bool},kr::Range)
   tol = 200.*eps()
    d = domain(B)
    
    if B.x == false && B.order == 0
        Float64[k==1?1.0:(k==2?-2.0:0.0) for k=kr]
    elseif B.x == true && B.order == 0
        Float64[k==1?1.0:0.0 for k=kr]
    else
        getindex(Evaluation(d,B.x,B.order)*Conversion(domainspace(B)),kr)
    end
end

Evaluation(sp::ChebyshevDirichletSpace,x::Float64,ord::Integer)=EvaluationWrapper(sp,x,ord,Evaluation(domain(sp),x,ord)*Conversion(sp))