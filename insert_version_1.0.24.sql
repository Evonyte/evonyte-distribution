-- Mark all previous versions as not latest
UPDATE versions SET is_latest = false WHERE is_latest = true;

-- Insert v1.0.24 as latest version
INSERT INTO versions (
    version,
    file_name,
    file_path,
    file_size,
    changelog,
    is_latest,
    is_active
) VALUES (
    '1.0.24',
    'evonyte-admin-v1.0.24-windows.zip',
    'evonyte-admin-v1.0.24-windows.zip',
    11534000,
    '🎨 UI Refresh: Removed retro Win98 styling, full Material Design 3
🔓 Simplified: Removed authentication system, direct Brain PC access
⚡ Performance: Cleaner codebase, faster startup
✨ Professional: Modern, clean interface for Brain PC management
🧹 Code cleanup: Removed unused auth dependencies',
    true,
    true
)
ON CONFLICT (version) DO UPDATE SET
    is_latest = true,
    is_active = true,
    changelog = EXCLUDED.changelog,
    file_size = EXCLUDED.file_size,
    updated_at = NOW();
