# Run one tiny CPU reference check: julia --project=@repo-oracles check-julia-reference.jl PACKAGE
# Set JULIA_NUM_THREADS=1 JULIA_NUM_PRECOMPILE_TASKS=1 OPENBLAS_NUM_THREADS=1 CUBACORES=0.
using LinearAlgebra, Random, TOML
length(ARGS) == 1 || error("Usage: check-julia-reference.jl PACKAGE")
name = only(ARGS)
row = Dict{String,Any}("package"=>name, "scope"=>"tiny CPU reference operation; no repository model or benchmark workload")
if name == "MeijerG"
    using MeijerG
    values = setprecision(192) do
        z=big"0.3"
        actual=[meijerg((),(),(big"0",),(),z),
                meijerg((big"-1",),(),(big"0",),(),z)]
        expected=[exp(-z),(1+z)^(-2)]
        @assert all(isfinite,actual)
        @assert maximum(abs.(actual.-expected)) < big"1e-12"
        Float64.(real.(actual))
    end
    bessel=meijerg((),(),(.25,.75),(),.3)
    expected=sqrt(pi)*.3^.25*exp(-2sqrt(.3))
    @assert isfinite(bessel)
    slater=meijerg_slater((),(.25,.75),2,0,.3)
    @assert isfinite(slater) && abs(slater-expected)<1e-12
    row["default_shifted_bessel_status"]="failed_independent_identity"
    row["default_shifted_bessel_error"]=abs(bessel-expected)
    row["bessel_expected"]=expected
    row["slater_bessel_value"]=real(slater)
    row["slater_bessel_error"]=abs(slater-expected)
    row["version"]=string(Base.pkgversion(MeijerG));row["values"]=values
    row["bigfloat_identity_precision_bits"]=192
    row["bessel_float64_value"]=real(bessel)
    row["limitation"]="Default shifted Bessel reduction uses wrong exponent sign and fails identity; BigFloat Bessel unsupported by SpecialFunctions; explicit Slater path and two192-bit elementary identities pass"
elseif name == "FastGaussQuadrature"
    using FastGaussQuadrature
    x,w=gausslegendre(32);v=dot(w,x.^2)
    @assert all(w .> 0) && all(abs.(x) .< 1) && abs(v-2/3)<1e-13
    row["version"]=string(Base.pkgversion(FastGaussQuadrature));row["integral"]=v
elseif name == "Integrals"
    using Integrals
    sol=solve(IntegralProblem((x,p)->x^2,(0.,1.)),QuadGKJL();abstol=1e-10,reltol=1e-10)
    @assert isfinite(sol.u) && abs(sol.u-1/3)<1e-12
    row["version"]=string(Base.pkgversion(Integrals));row["integral"]=sol.u
elseif name == "Cuba"
    using Cuba
    result=cuhre((x,f)->(f[1]=x[1]*x[2]),2,1;atol=1e-10,rtol=1e-10,maxevals=10000)
    @assert result.fail==0 && isfinite(result.integral[1]) && abs(result.integral[1]-.25)<1e-12
    row["version"]=string(Base.pkgversion(Cuba));row["integral"]=result.integral[1]
elseif name == "TemporalGPs"
    using AbstractGPs,KernelFunctions,TemporalGPs
    naive=GP(Matern32Kernel());fast=to_sde(naive,SArrayStorage(Float64))
    x=RegularSpacing(0.,.1,8);y=sin.(collect(x))
    fx=fast(x,.1);v=logpdf(fx,y);reference=logpdf(naive(collect(x),.1),y)
    @assert isfinite(v) && abs(v-reference)<1e-8
    post=posterior(fx,y);means=mean.(marginals(post(x)))
    @assert all(isfinite,means)
    row["version"]=string(Base.pkgversion(TemporalGPs));row["logpdf"]=v;row["dense_error"]=abs(v-reference)
elseif name == "Vecchia"
    using Vecchia,StaticArrays
    pts=[SVector{1,Float64}(x) for x in range(0,1;length=8)]
    data=sin.([p[1] for p in pts])
    kernel(x,y,p)=p[1]*exp(-sqrt(sum(abs2,x-y))/p[2])+(x==y ? p[3] : zero(p[3]))
    appx=VecchiaApproximation(pts,kernel,data;conditioning=KNNConditioning(3))
    v=appx([1.,.3,.01]);@assert isfinite(v)
    row["version"]=string(Base.pkgversion(Vecchia));row["negative_loglikelihood"]=v
elseif name == "OILMMs"
    using AbstractGPs,KernelFunctions,OILMMs
    U=reshape([inv(sqrt(2.)),inv(sqrt(2.))],2,1)
    f=OILMM([GP(SEKernel())],U,Diagonal([1.]),Diagonal([.1]))
    x=MOInput(collect(range(0,1;length=5)),2);fx=f(x,.05)
    y=rand(MersenneTwister(7),fx);v=logpdf(fx,y)
    @assert isfinite(v)
    post=posterior(fx,y);means=mean.(marginals(post(x)));@assert all(isfinite,means)
    row["version"]=string(Base.pkgversion(OILMMs));row["logpdf"]=v
else
    error("Unknown package")
end
row["status"] = name == "MeijerG" ? "pass_with_upstream_limitations" : "pass"
TOML.print(stdout,row;sorted=true)
