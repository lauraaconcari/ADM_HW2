# Define the input JSON file
$inputFile = "series.json"

# Load the JSON data from the input file
$seriesData = Get-Content $inputFile | ConvertFrom-Json

# Creare un hashtable per tenere traccia del totale dei books_count per ciascuna serie
$seriesTotals = @{}

# Itera attraverso i dati delle serie
$seriesData |
    Where-Object { $_.works -ne $null } |
    ForEach-Object {
        $series = $_
        $seriesTitle = $series.title
        $booksCount = ($series.works | Measure-Object -Property books_count -Sum).Sum
        if ($seriesTotals.ContainsKey($seriesTitle)) {
            # Aggiungi il totale al totale esistente
            $seriesTotals[$seriesTitle] += $booksCount
        } else {
            # Crea una nuova voce nel hashtable
            $seriesTotals[$seriesTitle] = $booksCount
        }
    }

# Ordina le serie in base al totale dei books_count in ordine decrescente
$topSeries = $seriesTotals.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5

# Creare un report file per memorizzare i risultati
$reportFile = "top_series_report.txt"

# Scrivi il report nel file
"Top 5 Series with the Highest Total 'books_count':" | Out-File -FilePath $reportFile
"" | Out-File -Append -FilePath $reportFile

# Loop attraverso le serie principali e scrivile nel file del report
foreach ($seriesEntry in $topSeries) {
    "Series: $($seriesEntry.Key), Total Books Count: $($seriesEntry.Value)" | Out-File -Append -FilePath $reportFile
}

# Mostra il report sulla console
Get-Content $reportFile

