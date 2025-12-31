#!/bin/bash
# Insert v1.0.24 into Supabase using service_role key

PROJECT_ID="brobuwegghwjhxlptffk"
SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJyb2J1d2VnZ2h3amh4bHB0ZmZrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNTIxNTUzNSwiZXhwIjoyMDUwNzkxNTM1fQ.hqskSmcCZWcEo6t4HM_7H9pKgj2k8RNJeYuMdDmKN-8"
BASE_URL="https://$PROJECT_ID.supabase.co/rest/v1"

echo "=== Updating Supabase Database to v1.0.24 ==="
echo ""

# Step 1: Mark all as not latest
echo "[1] Marking previous versions as not latest..."
curl -X PATCH "$BASE_URL/versions?is_latest=eq.true" \
  -H "apikey: $SERVICE_KEY" \
  -H "Authorization: Bearer $SERVICE_KEY" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '{"is_latest":false}'

echo ""
echo ""

# Step 2: Insert v1.0.24
echo "[2] Inserting v1.0.24..."
curl -X POST "$BASE_URL/versions" \
  -H "apikey: $SERVICE_KEY" \
  -H "Authorization: Bearer $SERVICE_KEY" \
  -H "Content-Type: application/json" \
  -H "Prefer: resolution=merge-duplicates,return=representation" \
  -d '{
    "version": "1.0.24",
    "file_name": "evonyte-admin-v1.0.24-windows.zip",
    "file_path": "evonyte-admin-v1.0.24-windows.zip",
    "file_size": 16777216,
    "changelog": "🎨 UI Refresh: Removed retro Win98 styling, full Material Design 3\n🔓 Simplified: Removed authentication system, direct Brain PC access\n⚡ Performance: Cleaner codebase, faster startup\n✨ Professional: Modern, clean interface for Brain PC management\n🧹 Code cleanup: Removed unused auth dependencies",
    "is_latest": true,
    "is_active": true
  }'

echo ""
echo ""

# Step 3: Verify
echo "[3] Verifying /latest endpoint..."
curl -s "https://$PROJECT_ID.supabase.co/functions/v1/latest" | python -m json.tool

echo ""
echo ""
echo "=== Done ==="
