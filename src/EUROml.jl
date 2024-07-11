module EUROml
    using DataFrames, CSV, DelimitedFiles, Dates, Plots
    using Lux, MLUtils, Optimisers, LossFunctions, Zygote, Random
    const Lexp = Lux.Experimental
    closeall()

    # ML model
    include("model.jl")
    include("load_data.jl")

    # App/Website
    include("predict_games.jl")
end