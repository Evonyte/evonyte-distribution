# Deploy Edge Functions to Supabase
# Automates deployment of all 4 Edge Functions

$PROJECT_ID = "brobuwegghwjhxlptffk"
$API_TOKEN = "sbp_0820b563c3686474d593f403e6631e290e073331"
$BASE_URL = "https://api.supabase.com/v1/projects/$PROJECT_ID"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYING EDGE FUNCTIONS TO SUPABASE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Function to deploy an Edge Function
function Deploy-Function {
    param(
        [string]$Name,
        [string]$FilePath
    )

    Write-Host "[*] Deploying function: $Name" -ForegroundColor Yellow

    # Read function code
    $body = Get-Content $FilePath -Raw

    # Create function
    $createPayload = @{
        slug = $Name
        name = $Name
        verify_jwt = $false
        body = $body
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod -Uri "$BASE_URL/functions" `
            -Method Post `
            -Headers @{
                "Authorization" = "Bearer $API_TOKEN"
                "Content-Type" = "application/json"
            } `
            -Body $createPayload

        Write-Host "[+] Function $Name deployed successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        $errorMessage = $_.Exception.Message
        if ($errorMessage -like "*already exists*") {
            Write-Host "[!] Function $Name already exists, updating..." -ForegroundColor Yellow

            # Update existing function
            try {
                $updatePayload = @{
                    body = $body
                } | ConvertTo-Json -Depth 10

                $updateResponse = Invoke-RestMethod -Uri "$BASE_URL/functions/$Name" `
                    -Method Patch `
                    -Headers @{
                        "Authorization" = "Bearer $API_TOKEN"
                        "Content-Type" = "application/json"
                    } `
                    -Body $updatePayload

                Write-Host "[+] Function $Name updated successfully!" -ForegroundColor Green
                return $true
            }
            catch {
                Write-Host "[-] Failed to update function $Name : $_" -ForegroundColor Red
                return $false
            }
        }
        else {
            Write-Host "[-] Failed to deploy function $Name : $_" -ForegroundColor Red
            return $false
        }
    }
}

# Deploy all functions
$functions = @(
    @{ Name = "health"; Path = "supabase\functions\health\index.ts" },
    @{ Name = "latest"; Path = "supabase\functions\latest\index.ts" },
    @{ Name = "download"; Path = "supabase\functions\download\index.ts" },
    @{ Name = "upload"; Path = "supabase\functions\upload\index.ts" }
)

$successCount = 0
foreach ($func in $functions) {
    if (Deploy-Function -Name $func.Name -FilePath $func.Path) {
        $successCount++
    }
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT SUMMARY" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Deployed: $successCount / $($functions.Count) functions" -ForegroundColor $(if ($successCount -eq $functions.Count) { "Green" } else { "Yellow" })
Write-Host ""

# Test endpoints
Write-Host "Testing endpoints..." -ForegroundColor Yellow
Write-Host ""

try {
    $healthResponse = Invoke-RestMethod -Uri "https://$PROJECT_ID.supabase.co/functions/v1/health"
    Write-Host "[+] Health check: OK" -ForegroundColor Green
    Write-Host "    Response: $($healthResponse.status)" -ForegroundColor Gray
}
catch {
    Write-Host "[-] Health check: FAILED" -ForegroundColor Red
}

Write-Host ""
Write-Host "Endpoints:" -ForegroundColor Cyan
Write-Host "  Health:   https://$PROJECT_ID.supabase.co/functions/v1/health" -ForegroundColor Gray
Write-Host "  Latest:   https://$PROJECT_ID.supabase.co/functions/v1/latest" -ForegroundColor Gray
Write-Host "  Download: https://$PROJECT_ID.supabase.co/functions/v1/download" -ForegroundColor Gray
Write-Host "  Upload:   https://$PROJECT_ID.supabase.co/functions/v1/upload" -ForegroundColor Gray
Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
