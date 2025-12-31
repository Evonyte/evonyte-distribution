import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async () => {
  return new Response(
    JSON.stringify({
      version: "1.0.24",
      file_name: "evonyte-admin-v1.0.24-windows.zip",
      file_size: 16777216,
      changelog: "Test deployment",
      released_at: "2025-12-30",
      download_url: "https://github.com/Evonyte/evonyte-distribution/releases/download/v1.0.24/evonyte-admin-v1.0.24-windows.zip"
    }),
    {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    }
  );
});
