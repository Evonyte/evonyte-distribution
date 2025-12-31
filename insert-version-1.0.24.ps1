# Insert version 1.0.24 into Supabase versions table

$PROJECT_ID = "brobuwegghwjhxlptffk"
# Using service role key for write access
$SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJyb2J1d2VnZ2h3amh4bHB0ZmZrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNTIxNTUzNSwiZXhwIjoyMDUwNzkxNTM1fQ.hqskSmcCZWcEo6t4HM_7H9pKgj2k8RNJeYuMdDmKN-8"
$BASE_URL = "https://$PROJECT_ID.supabase.co/rest/v1"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  INSERTING VERSION 1.0.24 INTO SUPABASE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Mark all previous versions as not latest
Write-Host "[*] Marking previous versions as not latest..." -ForegroundColor Yellow

try {
    $updatePayload = @{
        is_latest = $false
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$BASE_URL/versions?is_latest=eq.true" `
        -Method Patch `
        -Headers @{
            "apikey" = $SERVICE_KEY
            "Authorization" = "Bearer $SERVICE_KEY"
            "Content-Type" = "application/json"
            "Prefer" = "return=minimal"
        } `
        -Body $updatePayload

    Write-Host "[+] Previous versions updated" -ForegroundColor Green
}
catch {
    Write-Host "[-] Warning: Could not update previous versions: $_" -ForegroundColor Yellow
}

# Step 2: Insert/Update version 1.0.24
Write-Host "[*] Inserting version 1.0.24..." -ForegroundColor Yellow

$versionPayload = @{
    version = "1.0.24"
    file_name = "evonyte-admin-v1.0.24-windows.zip"
    file_path = "evonyte-admin-v1.0.24-windows.zip"
    file_size = 11534000
    changelog = @"
🎨 UI Refresh: Removed retro Win98 styling, full Material Design 3
🔓 Simplified: Removed authentication system, direct Brain PC access
⚡ Performance: Cleaner codebase, faster startup
✨ Professional: Modern, clean interface for Brain PC management
🧹 Code cleanup: Removed unused auth dependencies
"@
    is_latest = $true
    is_active = $true
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/versions" `
        -Method Post `
        -Headers @{
            "apikey" = $SERVICE_KEY
            "Authorization" = "Bearer $SERVICE_KEY"
            "Content-Type" = "application/json"
            "Prefer" = "return=representation,resolution=merge-duplicates"
        } `
        -Body $versionPayload

    Write-Host "[+] Version 1.0.24 inserted successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response:" -ForegroundColor Gray
    $response | ConvertTo-Json -Depth 5 | Write-Host -ForegroundColor Gray
}
catch {
    Write-Host "[-] Failed to insert version: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  VERSION 1.0.24 DEPLOYMENT COMPLETE" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 3: Verify by checking /latest endpoint
Write-Host "[*] Verifying /latest endpoint..." -ForegroundColor Yellow

try {
    $latestResponse = Invoke-RestMethod -Uri "https://$PROJECT_ID.supabase.co/functions/v1/latest"

    Write-Host "[+] Latest endpoint verification:" -ForegroundColor Green
    Write-Host "    Version: $($latestResponse.version)" -ForegroundColor Cyan
    Write-Host "    Download URL: $($latestResponse.download_url)" -ForegroundColor Gray
    Write-Host ""

    if ($latestResponse.version -eq "1.0.24") {
        Write-Host "[+] SUCCESS: Supabase now serves v1.0.24" -ForegroundColor Green
    } else {
        Write-Host "[!] WARNING: Latest version is $($latestResponse.version), not 1.0.24" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[-] Could not verify latest endpoint" -ForegroundColor Red
}

Write-Host ""
