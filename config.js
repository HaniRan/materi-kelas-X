// Isi dua nilai ini dari Supabase: Project Settings > API (atau Data API)
//   SUPABASE_URL      -> "Project URL", contoh: https://abcdefgh.supabase.co
//   SUPABASE_ANON_KEY -> kunci "anon" / "publishable" (BUKAN service_role)
// Kalau dikosongkan, kursus tetap bisa dibuka dalam mode uji coba (nilai tidak dikirim).
window.KURSUS_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: "",
  KKM: 70 // nilai minimal untuk membuka bab berikutnya
};
