// ============================================
// LATEST VERSION ENDPOINT
// GET /latest
// Returns hardcoded v1.0.25 info
// ============================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req: Request) => {
  const headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };

  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers });
  }

  if (req.method !== "GET") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers }
    );
  }

  try {
    const response = {
      version: "1.0.25",
      file_name: "evonyte-admin-v1.0.25-windows.zip",
      file_size: 13631488,
      changelog: "🎨 Material Design 3: Win98 compatibility layer for smooth transition\n🔧 Brain PC Widgets: Fixed monitoring widgets imports\n📄 PDF Export: Service stubbed for Windows build compatibility\n⚡ Build System: Clean dependency resolution",
      released_at: "2025-12-31",
      download_url: "https://github.com/Evonyte/evonyte-distribution/releases/download/v1.0.25/evonyte-admin-v1.0.25-windows.zip",
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers,
    });
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: "Internal server error",
        message: String(error),
      }),
      { status: 500, headers }
    );
  }
});
