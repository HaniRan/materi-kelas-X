-- =========================================================
-- Database nilai Kursus Perulangan For
-- Jalankan seluruh file ini di Supabase: SQL Editor > New query > Run
-- =========================================================

-- 1. Tabel nilai kuis (satu baris = satu kali siswa mengirim kuis)
create table if not exists public.nilai_kuis (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  nama         text not null check (char_length(nama) between 2 and 80),
  kelas        text not null check (char_length(kelas) between 1 and 20),
  no_absen     int  check (no_absen between 1 and 99),
  bab          int  not null check (bab between 1 and 20),
  judul_bab    text,
  skor         int  not null check (skor between 0 and 100),
  benar        int  not null check (benar >= 0),
  jumlah_soal  int  not null check (jumlah_soal > 0),
  percobaan    int  not null default 1,
  lulus        boolean not null default false,
  jawaban      jsonb
);

create index if not exists nilai_kuis_kelas_idx on public.nilai_kuis (kelas, nama);

-- 2. Daftar email guru yang boleh melihat rekap nilai
create table if not exists public.guru (
  email text primary key
);

-- GANTI email di bawah dengan email akun guru yang dibuat di
-- Authentication > Users. Tambah baris lain untuk guru tambahan.
insert into public.guru (email) values ('email-guru@sekolah.sch.id')
on conflict do nothing;

-- 3. Keamanan (Row Level Security)
alter table public.nilai_kuis enable row level security;
alter table public.guru       enable row level security;

-- Siswa (tanpa login) hanya boleh MENGIRIM nilai, tidak bisa melihat nilai siapa pun
drop policy if exists "siswa kirim nilai" on public.nilai_kuis;
create policy "siswa kirim nilai" on public.nilai_kuis
  for insert to anon, authenticated
  with check (true);

-- Hanya guru yang terdaftar yang boleh melihat & menghapus nilai
drop policy if exists "guru lihat nilai" on public.nilai_kuis;
create policy "guru lihat nilai" on public.nilai_kuis
  for select to authenticated
  using (exists (select 1 from public.guru g where g.email = auth.jwt() ->> 'email'));

drop policy if exists "guru hapus nilai" on public.nilai_kuis;
create policy "guru hapus nilai" on public.nilai_kuis
  for delete to authenticated
  using (exists (select 1 from public.guru g where g.email = auth.jwt() ->> 'email'));

drop policy if exists "guru lihat daftar guru" on public.guru;
create policy "guru lihat daftar guru" on public.guru
  for select to authenticated
  using (email = auth.jwt() ->> 'email');
