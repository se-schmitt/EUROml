module EUROml
    using DataFrames, CSV, Dates, Plots
    using Lux, MLUtils, Optimisers, LossFunctions, Zygote, Random
    const Lexp = Lux.Experimental
    closeall()

    # ML model
    include("model.jl")
    include("load_data.jl")

    # App/Website
end