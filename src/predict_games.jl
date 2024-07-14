# Function to predict EURO games by a given model
function predict_games(model,team2id;name="",root_dir=".")
    # Load games
    games = CSV.File("$root_dir/data/games_EURO.csv") |> DataFrame

    statistics = Dict(
        "Points" => 0,
        "# correct results" => 0,
        "# correct winner (accuracy)" => 0,
    )

    # Predict group stage and finals
    for stage in [string.("group ",'A':'F');"round of 16";"quarter finals";"semi finals";"final"]
        what = games.stage .== stage
        results_stage = Matrix{Int64}(undef,0,2)
        colors = String[]
        for id in findall(what)
            result_id = round.(Int64,model(team2id[games.home_team[id]],team2id[games.away_team[id]],year2float(games.date[id]),false))
            if ismissing(games.home_score[id])
                color = "gray"
            else
                color = all(result_id .== [games.home_score[id],games.away_score[id]]) ? "lime" : 
                        result_id[1]-result_id[2] == games.home_score[id]-games.away_score[id] ? "green" :
                        sign(result_id[1]-result_id[2]) == sign(games.home_score[id]-games.away_score[id]) ? "blue" : "red"
            end
            push!(colors,color)
            results_stage = [results_stage;result_id']
        end
        open("$root_dir/docs/_data/$name/$(replace(stage," "=>"")).csv","w") do io
            println(io,"home_team,away_team,date,pred_home,pred_away,result_home,result_away,color")
            writedlm(io,[games.home_team[what] games.away_team[what] games.date[what] results_stage games.home_score[what] games.away_score[what] colors],',')
        end

        # Calculate kicktip points
        statistics["Points"] += sum(colors .== "lime")*4 + sum(colors .== "green")*3 + sum(colors .== "blue")*2
        statistics["# correct results"] += sum(colors .!= "lime")
        statistics["# correct winner (accuracy)"] += sum(in.(colors,Ref(["lime","green","blue"])))
    end
    open("$root_dir/docs/_data/$name/statistics.csv","w") do io
        println(io,"key,value")
        println(io,"Points,",statistics["Points"])
        println(io,"# correct results,",statistics["# correct results"])
        println(io,"# correct winner (accuracy),",statistics["# correct winner (accuracy)"])
    end
end