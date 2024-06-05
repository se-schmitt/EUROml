# Script to test model for group stage
using Dates

include("EUROml.jl")

using .EUROml

# Load data
results, scorers, shootouts = EUROml.load_data()
data, team2id, id2team = EUROml.convert_data(results, scorers, shootouts)

# Model
model = EUROml.build_model(maximum(data.id_home_team), size(data,2)-2)
trained_model = EUROml.train_model(model,data)

what_group = results.tournament .== "UEFA Euro" .&& year.(results.date) .== 2024 .&& results.home_team .!= "NA"
group_matches = [(results.home_team[i],results.away_team[i],(year.(results.date[i]) .+ dayofyear.(results.date[i]) ./ daysinyear.(results.date[i]))) for i in findall(what_group)]

for (team1,team2,date) in group_matches
    y_pred = trained_model(team2id[team1],team2id[team2],date,false)
    (str1,str2) = [t*" "^(15-length(t)) for t in [team1,team2]]
    println("Prediction: ",str1," vs. ",str2,": ",round(y_pred[1,1],digits=5)," - ",round(y_pred[2,1],digits=5))
end
