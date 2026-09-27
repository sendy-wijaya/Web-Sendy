-- ============================================
-- Jalankan skrip ini di Supabase > SQL Editor
-- untuk membuat tabel penyimpanan data pengunjung.
-- ============================================

create table if not exists visitors (
  id uuid primary key default gen_random_uuid(),
  visitor_id text unique not null,
  nama text not null,
  perangkat text,
  jawaban text,
  waktu_masuk timestamptz not null default now(),
  waktu_terakhir timestamptz not null default now()
);

-- Aktifkan Row Level Security supaya tabel ini TIDAK BISA
-- diakses langsung oleh siapa pun dari sisi frontend/anon key.
-- Netlify Functions mengakses tabel ini lewat "service role key",
-- yang secara otomatis melewati (bypass) RLS ini dengan aman.
alter table visitors enable row level security;

-- Tidak ada policy yang dibuat secara sengaja:
-- artinya akses publik (anon key) akan DITOLAK sepenuhnya,
-- dan hanya service role key (dipakai di backend) yang bisa membaca/menulis.

-- Index tambahan agar pengambilan data lebih cepat
create index if not exists idx_visitors_waktu_terakhir on visitors (waktu_terakhir desc);
