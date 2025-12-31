-- Insert v1.0.22 as latest version
INSERT INTO versions (
    version,
    file_name,
    file_path,
    file_size,
    changelog,
    is_latest,
    is_active
) VALUES (
    '1.0.22',
    'evonyte-admin-v1.0.22-windows.zip',
    'evonyte-admin-v1.0.22-windows.zip',
    0,
    '🔄 NEW: Auto-update checker - Check for updates button in Dashboard
✨ Brain PC: New sidebar navigation (System Monitor, Services Control, Docker Control)
🐳 Docker Control: Manage containers (start/stop/logs) directly from Admin App
⚙️ Services Control: Enhanced systemd service management
📊 System Monitor: Real-time hardware metrics dashboard
🔧 Connection status indicator in Brain PC sidebar',
    true,
    true
)
ON CONFLICT (version) DO UPDATE SET
    is_latest = true,
    is_active = true,
    changelog = EXCLUDED.changelog,
    updated_at = NOW();
