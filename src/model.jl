# Function to build model
struct EuroModel{L1, L2} <: Lux.AbstractExplicitContainerLayer{(:embedding, :core)}
    embedding::L1
    core::L2
end

function (em::EuroModel)(x::AbstractArray, ps, st::NamedTuple)
    # Apply embedding to first two input rows
    emb_out = [em.embedding(Int64.(x[i,:]),ps.embedding,st.embedding) for i in 1:2]
    emb = vcat([e[1] for e in emb_out]...)
    st_emb = emb_out[1][2]

    # Concatenate the embedding with the rest of the input
    x_cat = [emb; x[3:4,:];]

    # Apply the core model
    y, st_core = em.core(x_cat, ps.core, st.core)

    return y, (embedding = st_emb, core = st_core)
end


"""
    build_model(no_teams::Int, input_dim::Int)

Build a neural network model for predicting football scores.
"""
function build_model_A(N_teams::Int)
    # Settings
    N_emb = 6

    return EuroModel(
        Chain(
            Embedding(N_teams => N_emb)
        ), 
        Chain(
            Dropout(0.1),
            Dense(2*N_emb+2,8,relu),
            Dense(8,4,relu),
            Dense(4,2)
        )
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
    # score loss:
    loss_score = sum([sum(lossf_scrs.(y_pred[i,:], Y[i,:])) for i in 1:2])
    # rounded result loss:
    diff_data = Y[1,:].-Y[2,:]
    diff_pred = round.(y_pred[1,:]).-round.(y_pred[2,:])
    diff = sign.(diff_data.*diff_pred) .* abs.(diff_data.-diff_pred)
    loss_result = sum(lossf_res.(diff))

    # Calculate accuracy
    accuracy = sum(diff .≥ 0) / length(diff)

    return loss_score .+ loss_result, st, (;accuracy=accuracy)
end

# Function to train model
function train_model(model, data; epochs=20, batch_size=1024, name="")
    # Create training, validation and test sets 
    #=  (80% training, 10% validation, 10% test)
        Currently: first 80 % of games, remaining 20 % randomly split
        Future: better methods for times series data?=#
    sort!(data, :date)
    (min_date, max_date) = (minimum(data.date), maximum(data.date))
    data[!,:date_norm] = (data.date .- min_date) ./ (max_date - min_date)
    what_train, what_val = splitobs(shuffleobs(1:size(data,1)),at=0.9)
    
    # Create data loaders
    features = Matrix(data[:,[:id_home_team,:id_away_team,:date_norm,:is_friendly]])
    labels = Matrix(data[:,[:home_score,:away_score]])
    train_loader = DataLoader((features[what_train,:]', labels[what_train,:]'), batchsize=batch_size, shuffle=true)
    val_loader = DataLoader((features[what_val,:]', labels[what_val,:]'), batchsize=batch_size)

    # Create train state
    tstate = Lexp.TrainState(Xoshiro(0), model, Adam(0.01f0))

    L_tr = zeros(epochs)
    L_val = zeros(epochs)
    Acc_tr = zeros(epochs)
    Acc_val = zeros(epochs)

    for epoch in 1:epochs
        # Train the model
        for (x, y) in train_loader
            gs, loss, stats, tstate = Lexp.compute_gradients(AutoZygote(), compute_loss, (x, y), tstate)
            tstate = Lexp.apply_gradients!(tstate, gs)
            L_tr[epoch] += loss/size(y)[end]/length(train_loader)
            Acc_tr[epoch] += stats.accuracy*size(y)[end]/length(what_train)
        end

        # Validate the model
        st_ = Lux.testmode(tstate.states)
        for (x, y) in val_loader
            loss, st_, stats = compute_loss(model, tstate.parameters, st_, (x, y))
            L_val[epoch] += loss/size(y)[end]/length(val_loader)
            Acc_val[epoch] += stats.accuracy*size(y)[end]/length(what_val)
        end
    end

    if !isempty(name)
        # Plot loss
        fields = (:yaxis, :lab, :title_loc, :color, :y_foreground_color_axis, :y_foreground_color_border, :y_foreground_color_text, :y_guidefontcolor)
        kw_blue = NamedTuple{fields}(["score loss","",:left, repeat([:blue],5)...])
        kw_red = NamedTuple{fields}(["accuracy","",:right, repeat([:red],5)...])
        plot(1:epochs, log10.(L_tr), xaxis = "epochs", xlims = (1, epochs); kw_blue...)
        plot!(1:epochs, log10.(L_val), xaxis = "epochs", xlims = (1, epochs), lc=:deepskyblue; kw_blue...)
        plt = plot!(twinx(), 1:epochs, Acc_val; kw_red...)
        gui(plt)
        savefig("$name.png")
    end

    # Create output
    model_trained(id_t1,id_t2,date,is_friendly) = model([id_t1,id_t2,(date-min_date)/(max_date-min_date),is_friendly], tstate.parameters, Lux.testmode(tstate.states))[1]
    stats = (;training=(;loss=L_tr,accuracy=Acc_tr),validation=(;loss=L_val,accuracy=Acc_val))

    return model_trained, stats, tstate
end