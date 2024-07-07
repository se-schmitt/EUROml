# Load data from results.csv, goalscorers.csv, and shootouts.csv to DataFrames
function load_data(;dir=".")
    results = CSV.File("$dir/data/results.csv") |> DataFrame
    scorers = CSV.File("$dir/data/goalscorers.csv") |> DataFrame
    shootouts = CSV.File("$dir/data/shootouts.csv") |> DataFrame

    return results, scorers, shootouts
end

# Convert training data including filtering to make it ready for training
function convert_data(results, scorers, shootouts; output=true)
    # Settings
    teams_exclude = ["NA"]
    min_nr_games = 20
    min_year = 1960

    # Filter teams and games (by number of games per team and year)
    teams = unique(vcat(results.home_team, results.away_team))
    what_valid_year = year.(results.date) .≥ min_year
    what_games = deepcopy(what_valid_year)
    for i in 1:20
        if output
            println("i: ",i,"; No. teams: ",length(teams))
        end
        games_per_team = [sum([results.home_team[what_games];results.away_team[what_games]] .== team) for team in teams]
        what_teams = @. games_per_team > min_nr_games && !in(teams,Ref(teams_exclude))
        teams = sort(teams[what_teams])                             # Could be sorted by number of games??

        N_teams_old = sum(what_games)
        what_games = what_valid_year .&& in.(results.home_team,Ref(teams)) .&& in.(results.away_team,Ref(teams))
        if sum(what_games) == N_teams_old
            break
        end
    end

    # Filter out games with NA scores
    what_games = what_games .&& results.home_score .≠ "NA" .&& results.away_score .≠ "NA"

    # Assign team IDs
    team2id = Dict(team => i for (i, team) in enumerate(teams))
    id2team = Dict(i => team for (team, i) in team2id)

    # Construct dataset
    data = DataFrame(
        id_home_team = getindex.(Ref(team2id),results.home_team[what_games]),
        id_away_team = getindex.(Ref(team2id),results.away_team[what_games]),
        home_score = results.home_score[what_games],
        away_score = results.away_score[what_games],
        date = (year.(results.date) .+ dayofyear.(results.date) ./ daysinyear.(results.date))[what_games],
        is_friendly = results.tournament[what_games] .== "Friendly",
    )

    return data, team2id, id2team
end