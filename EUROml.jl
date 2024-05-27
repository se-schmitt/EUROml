module EUROml
    using DataFrames, CSV, Dates
    using Lux, MLUtils, Optimisers, LossFunctions, Zygote, Random
    const Lexp = Lux.Experimental

    # ML model
    include("src/model.jl")
    include("src/load_data.jl")

    # App/Website
end