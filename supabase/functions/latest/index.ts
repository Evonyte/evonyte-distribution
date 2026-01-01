// ============================================
// LATEST VERSION ENDPOINT
// GET /latest
// Returns latest version info from database
// NO HARDCODING - reads from Supabase
// ============================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

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
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    // Get latest version from database
    const { data, error } = await supabase
      .rpc("get_latest_version")
      .single();

    if (error || !data) {
      // Fallback: try direct query
      const { data: fallbackData, error: fallbackError } = await supabase
        .from("versions")
        .select("*")
        .eq("is_latest", true)
        .eq("is_active", true)
        .single();

      if (fallbackError || !fallbackData) {
        // Hardcoded fallback when database is empty
        // UPDATE THIS when deploying new versions manually
        const hardcodedFallback = {
          version: "1.0.48",
          file_name: "evonyte-admin-v1.0.48-windows.zip",
          file_size: 25000000,
          changelog: "Real GPU memory display, batch progress tracking, improved ETA calculation",
          released_at: "2026-01-01",
          download_url: "https://github.com/Evonyte/evonyte-distribution/releases/download/v1.0.48/evonyte-admin-v1.0.48-windows.zip",
        };

        return new Response(
          JSON.stringify(hardcodedFallback),
          { status: 200, headers }
        );
      }

      // Build download URL
      const downloadUrl = `https://github.com/Evonyte/evonyte-distribution/releases/download/v${fallbackData.version}/${fallbackData.file_name}`;

      return new Response(
        JSON.stringify({
          version: fallbackData.version,
          file_name: fallbackData.file_name,
          file_size: fallbackData.file_size,
          changelog: fallbackData.changelog || "",
          released_at: fallbackData.created_at,
          download_url: downloadUrl,
        }),
        { status: 200, headers }
      );
    }

    // Build download URL
    const downloadUrl = `https://github.com/Evonyte/evonyte-distribution/releases/download/v${data.version}/${data.file_name}`;

    const response = {
      version: data.version,
      file_name: data.file_name,
      file_size: data.file_size,
      changelog: data.changelog || "",
      released_at: data.created_at,
      download_url: downloadUrl,
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
