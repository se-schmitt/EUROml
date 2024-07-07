# Script to test model for group stage
include("../src/EUROml.jl")
using Dates, JLD2, .EUROml

# Load data
results, scorers, shootouts = EUROml.load_data()
data, team2id, id2team = EUROml.convert_data(results, scorers, shootouts)

# Model
model = EUROml.build_model(maximum(data.id_home_team))

what_group = results.tournament .== "UEFA Euro" .&& year.(results.date) .== 2024 .&& results.home_team .!= "NA"
group_matches = [(results.home_team[i],results.away_team[i],(year.(results.date[i]) .+ dayofyear.(results.date[i]) ./ daysinyear.(results.date[i]))) for i in findall(what_group)]

hyper_analysis = Dict{Tuple{Int,Int},Tuple}()

name = "hyper_5_do_0.1"

for e in [500], bs = [1024]
    model_i, stats_i, tstate_i = EUROml.train_model(model,data;epochs=e,batch_size=bs,name="DEBUG/$(name)_$(e)_$(bs)")
    
    matches_i = Dict{Tuple{String,String},Tuple{Float64,Float64}}()
    for (team1,team2,date) in group_matches
        y_pred = model_i(team2id[team1],team2id[team2],date,false)
        matches_i[(team1,team2)] = (y_pred[1,1],y_pred[2,1])
    end

    hyper_analysis[(e,bs)] = (matches_i,model_i,stats_i,tstate_i)

    println(Dates.format(now(), "yyyy-mm-dd HH:MM:SS")," - Epochs: ",e," Batch size: ",bs," Validation loss: ",stats_i.validation.loss[end])
end

jldsave("DEBUG/$name.jld2";hyper_analysis)

