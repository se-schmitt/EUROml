using HTTP
using CSV

error("API key required!")

function download_csv(url::AbstractString, save_path::AbstractString)
    response = HTTP.get(url)
    if response.status == 200
        data = String(response.body)
        CSV.write(save_path, CSV.File(IOBuffer(data)))
        println("Die CSV-Datei wurde erfolgreich heruntergeladen und unter $save_path gespeichert.")
    else
        println("Fehler beim Herunterladen der CSV-Datei.")
    end
end

# Beispielaufruf
url = "https://www.kaggle.com/datasets/martj42/international-football-results-from-1872-to-2017?select=results.csv"
save_path = "./data.csv"
download_csv(url, save_path)