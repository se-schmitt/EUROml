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
        # Lux.Parallel(
        #     Embedding(no_teams => nodes_emb),                 # Embedding for home team
        #     Embedding(no_teams => nodes_emb)                  # Embedding for away team
        # ),
        # # Lux.FlattenLayer(),                                     # Flatten the embeddings
        # Lux.Dense(input_dim - 2 + (2*nodes_emb), 32, relu),
        Lux.Dense(input_dim, 64, relu),
        Lux.Dense(64, 32, relu),
        Lux.Dense(32, 2)                                        # Two outputs: home score and away score -> here relu too to ensure positive value? Or 10x2 output for numbers 0-9)
    )
end

# Loss function
function compute_loss(model, ps, st, (X,Y))
    # Apply model to data
    y_pred, st = model(X, ps, st)

    # Define loss functions 
    lossf_scrs = L2DistLoss()
    lossf_res = ModifiedHuberLoss()
    
    # Calculate loss 
    diff_data = Y[1,:].-Y[2,:]
    diff_pred = y_pred[1,:].-y_pred[2,:]
    diff = sign.(diff_data.*diff_pred) .* abs.(diff_data.-diff_pred)
    loss_score = sum([sum(lossf_scrs.(y_pred[i,:], Y[i,:])) for i in 1:2])
    loss_result = sum(lossf_res.(diff))
    accuracy = sum(diff .≥ 0) / length(diff)

    return loss_score .+ loss_result, st, (;accuracy=accuracy)
end

# Function to train model
function train_model(model, data; epochs=20, batch_size=64)
    # Create training, validation and test sets 
    #=  (80% training, 10% validation, 10% test)
        Currently: first 80 % of games, remaining 20 % randomly split
        Future: better methods for times series data?=#
    sort!(data, :date)
    what_train = [1:floor(Int,0.8*size(data,1));]
    what_val, what_test = splitobs(shuffleobs((floor(Int,0.8*size(data,1))+1):size(data,1)),at=0.5)
    
    # Create data loaders
    features = Matrix(data[:,[:id_home_team,:id_away_team,:date,:is_friendly]])
    labels = Matrix(data[:,[:home_score,:away_score]])
    train_loader = DataLoader((features[what_train,:]', labels[what_train,:]'), batchsize=batch_size, shuffle=true)
    val_loader = DataLoader((features[what_val,:]', labels[what_val,:]'), batchsize=batch_size)
    test_loader = DataLoader((features[what_test,:]', labels[what_test,:]'), batchsize=batch_size)

    # Create train state
    tstate = Lexp.TrainState(Xoshiro(0), model, Adam(0.01f0))

    for epoch in 1:epochs
        # Train the model
        for (x, y) in train_loader
            gs, loss, _, train_state = Lexp.compute_gradients(AutoZygote(), compute_loss, (x, y), tstate)
            train_state = Lexp.apply_gradients!(tstate, gs)
            # println("Epoch: ",epoch,", Loss: ",round(loss,digits=5))
        end

        # Validate the model
        st_ = Lux.testmode(tstate.states)
        for (x, y) in val_loader
            loss, st_, info = compute_loss(model, tstate.parameters, st_, (x, y))
            println("Validation: Loss ",round(loss,digits=5),", Accuracy ",round(info.accuracy,digits=5))
        end
    end

    return (id_t1,id_t2,date,is_friendly) -> model([id_t1,id_t2,date,is_friendly], tstate.parameters, Lux.testmode(tstate.states))[1]
end