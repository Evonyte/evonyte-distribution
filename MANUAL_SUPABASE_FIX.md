# INSTRUKCJA: Ręczna Naprawa Supabase Edge Function `/latest`

## ⚠️ PROBLEM

API deployment przez `PATCH` request powoduje `BOOT_ERROR` we wszystkich próbach.
Próbowano 10+ razy z różnym kodem - zawsze ten sam błąd.

**Jedyne rozwiązanie:** Ręczny deployment przez Supabase Dashboard.

---

## ✅ CO DZIAŁA TERAZ

- ✅ Strona evonyte.com pokazuje v1.0.24
- ✅ GitHub Release v1.0.24 exists
- ✅ Download URL działa
- ✅ version.json zaktualizowany
- ❌ `/latest` endpoint zwraca BOOT_ERROR (był v1.0.23, teraz zepsuty)

---

## 📋 KROKI NAPRAWY

### OPCJA A: Hardcoded v1.0.24 (NAJPROSTSZE - 2 minuty)

1. **Idź na:** https://supabase.com/dashboard
2. **Zaloguj się**
3. **Wybierz projekt:** `brobuwegghwjhxlptffk`
4. **Kliknij:** Edge Functions → `latest`
5. **Skasuj** cały kod w edytorze
6. **Wklej** kod z: `evonyte-distribution/supabase/functions/latest/index-simple.ts`
7. **Kliknij:** Deploy

**Test:**
```bash
curl https://brobuwegghwjhxlptffk.supabase.co/functions/v1/latest
```

Powinno zwrócić v1.0.24.

---

### OPCJA B: Z bazą danych (potrzebna naprawa bazy)

1. **Deploy funkcji** (jak w Opcji A ale użyj `index-backup.ts`)
2. **Napraw bazę danych:**

```sql
-- W Supabase Dashboard → SQL Editor:

-- Oznacz poprzednie wersje jako nie-latest
UPDATE versions SET is_latest = false WHERE is_latest = true;

-- Dodaj v1.0.24
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
    16777216,
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
    updated_at = NOW();
```

---

## 📂 PLIKI DO UŻYCIA

**Lokalizacja:** `D:\evonyte_desktop\evonyte-distribution\supabase\functions\latest\`

- `index-simple.ts` - Hardcoded v1.0.24 (ZALECANE - zawsze działa)
- `index-backup.ts` - Wersja z bazą danych (wymaga naprawy bazy)

---

## ✅ WERYFIKACJA

Po deployu sprawdź:

```bash
# 1. Endpoint działa
curl https://brobuwegghwjhxlptffk.supabase.co/functions/v1/latest

# Powinno zwrócić:
# {"version":"1.0.24", "file_name":"evonyte-admin-v1.0.24-windows.zip", ...}

# 2. Download URL działa
# https://github.com/Evonyte/evonyte-distribution/releases/download/v1.0.24/evonyte-admin-v1.0.24-windows.zip
```

---

## 📊 PODSUMOWANIE

**Gotowe (100%):**
- Strona WWW ✅
- GitHub Release ✅
- version.json ✅
- Kod funkcji edge przygotowany ✅

**Wymaga ręcznej akcji:**
- Deploy edge function przez Dashboard (2 min)

---

## ℹ️ DLACZEGO NIE DZIAŁA PRZEZ API?

Próbowano deployment przez:
- PowerShell + Invoke-RestMethod (timeout)
- Python + requests (timeout)
- Node.js + https (SUCCESS ale BOOT_ERROR)
- curl (problemy z escaping)

**Wszystkie metody** zwracają `BOOT_ERROR` przy próbie uruchomienia funkcji, mimo że:
- Deployment zwraca 200 OK
- /health endpoint działa
- Kod jest identyczny z działającym /health

**Wniosek:** Problem z API lub konfiguracją projektu, wymaga Dashboard.
