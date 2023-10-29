$data = Get-Content "series.json" | ConvertFrom-Json
$topSeries = $data | Where-Object { $_.works -ne $null } | Sort-Object { ($_.works | Measure-Object -Property books_count -Sum).Sum } -Descending | Select-Object -First 5
$topSeries | ForEach-Object { "Series: $($_.title), Total Books Count: $([string]::Format('{0:N0}', ($_.works | Measure-Object -Property books_count -Sum).Sum))" }