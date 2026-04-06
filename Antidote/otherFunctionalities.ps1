function functionPresentation {
    param(
        [string]$text
    )

    Write-Host "`n"
    Write-Host "----- $text -----" -ForegroundColor yellow
    Write-Host "`n"
}