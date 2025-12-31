#!/usr/bin/env python3
"""Deploy /latest Edge Function to Supabase"""

import requests
import json
import sys

PROJECT_ID = "brobuwegghwjhxlptffk"
API_TOKEN = "sbp_0820b563c3686474d593f403e6631e290e073331"
BASE_URL = f"https://api.supabase.com/v1/projects/{PROJECT_ID}"

def deploy_function():
    print("=" * 50)
    print("  DEPLOYING /latest EDGE FUNCTION")
    print("=" * 50)
    print()

    # Read function code
    print("[1/3] Reading function code...")
    with open("supabase/functions/latest/index.ts", "r", encoding="utf-8") as f:
        function_code = f.read()

    print(f"     Code size: {len(function_code)} bytes")
    print()

    # Deploy to Supabase
    print("[2/3] Deploying to Supabase...")

    headers = {
        "Authorization": f"Bearer {API_TOKEN}",
        "Content-Type": "application/json"
    }

    payload = {
        "body": function_code
    }

    try:
        response = requests.patch(
            f"{BASE_URL}/functions/latest",
            headers=headers,
            json=payload,
            timeout=30
        )

        if response.status_code in [200, 201]:
            print("     ✅ Deployment SUCCESS!")
        else:
            print(f"     ❌ Deployment FAILED: {response.status_code}")
            print(f"     Response: {response.text}")
            return False

    except Exception as e:
        print(f"     ❌ Error: {e}")
        return False

    print()

    # Test endpoint
    print("[3/3] Testing endpoint...")
    import time
    time.sleep(3)  # Wait for deployment to propagate

    try:
        test_response = requests.get(
            f"https://{PROJECT_ID}.supabase.co/functions/v1/latest",
            timeout=10
        )

        if test_response.status_code == 200:
            data = test_response.json()
            print("     ✅ Endpoint TEST SUCCESS!")
            print(f"     Version: {data.get('version')}")
            print(f"     Download: {data.get('download_url')}")

            if data.get('version') == '1.0.24':
                print()
                print("=" * 50)
                print("  ✅ DEPLOYMENT COMPLETE - v1.0.24 LIVE!")
                print("=" * 50)
                return True
            else:
                print(f"     ⚠️  Warning: Expected v1.0.24, got {data.get('version')}")
                return False
        else:
            print(f"     ❌ Endpoint test failed: {test_response.status_code}")
            print(f"     Response: {test_response.text}")
            return False

    except Exception as e:
        print(f"     ❌ Test error: {e}")
        return False

if __name__ == "__main__":
    success = deploy_function()
    sys.exit(0 if success else 1)
