# Deploy only /latest Edge Function to Supabase

$PROJECT_ID = "brobuwegghwjhxlptffk"
$API_TOKEN = "sbp_0820b563c3686474d593f403e6631e290e073331"
$BASE_URL = "https://api.supabase.com/v1/projects/$PROJECT_ID"

Write-Host "Deploying /latest function..." -ForegroundColor Yellow

# Read function code
$body = Get-Content "supabase\functions\latest\index.ts" -Raw

# Update function
$payload = @{
    body = $body
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/functions/latest" `
        -Method Patch `
        -Headers @{
            "Authorization" = "Bearer $API_TOKEN"
            "Content-Type" = "application/json"
        } `
        -Body $payload

    Write-Host "[+] Function deployed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "[-] Deploy failed: $_" -ForegroundColor Red
    exit 1
}

# Test endpoint
Write-Host ""
Write-Host "Testing endpoint..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

try {
    $testResponse = Invoke-RestMethod -Uri "https://$PROJECT_ID.supabase.co/functions/v1/latest"
    Write-Host "[+] Endpoint test SUCCESS:" -ForegroundColor Green
    Write-Host "    Version: $($testResponse.version)" -ForegroundColor Cyan
    Write-Host "    Download: $($testResponse.download_url)" -ForegroundColor Gray
}
catch {
    Write-Host "[-] Endpoint test failed: $_" -ForegroundColor Red
}
