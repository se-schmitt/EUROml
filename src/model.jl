# Function to build model
"""
    build_model(no_teams::Int, input_dim::Int)

Builds a simple feedforward neural network model for predicting football scores.
"""
function build_model(no_teams::Int, input_dim::Int)
    # Settings
    nodes_emb = 8

    Lux.Chain(
        # Embedding layers for home and away teams
        Lux.Parallel(
            Lux.Embedding(no_teams, nodes_emb),                 # Embedding for home team
            Lux.Embedding(no_teams, nodes_emb)                  # Embedding for away team
        ),
        Lux.Flatten(),  # Flatten the embeddings
        Lux.Dense(input_dim - 2 + (2*nodes_emb), 128, relu),    
        Lux.Dense(128, 64, relu),
        Lux.Dense(64, 32, relu),
        Lux.Dense(32, 2)                                        # Two outputs: home score and away score -> here relu too?
    )
end