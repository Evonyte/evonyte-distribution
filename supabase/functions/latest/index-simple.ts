// ============================================
// LATEST VERSION ENDPOINT
// GET /latest
// Returns hardcoded v1.0.24 info
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
      version: "1.0.24",
      file_name: "evonyte-admin-v1.0.24-windows.zip",
      file_size: 16777216,
      changelog: "🎨 UI Refresh: Removed retro Win98 styling, full Material Design 3\n🔓 Simplified: Removed authentication system, direct Brain PC access\n⚡ Performance: Cleaner codebase, faster startup\n✨ Professional: Modern, clean interface for Brain PC management\n🧹 Code cleanup: Removed unused auth dependencies",
      released_at: "2025-12-30",
      download_url: "https://github.com/Evonyte/evonyte-distribution/releases/download/v1.0.24/evonyte-admin-v1.0.24-windows.zip",
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
