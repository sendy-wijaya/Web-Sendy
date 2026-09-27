# 🌸 Website Sendy — Panduan Lengkap

Website kecil yang lucu, romantis, dan interaktif: pengunjung mengetik nama,
disapa secara personal, menjawab satu pertanyaan, lalu mendapat respons dan
animasi yang berbeda-beda. Semua kunjungan dicatat diam-diam ke database, dan
hanya pemilik website yang bisa melihatnya lewat halaman `/admin` yang
terkunci dengan username & password.

Panduan ini ditulis untuk orang yang **belum pernah** membuat database atau
deploy website. Ikuti urutannya dari atas ke bawah.

---

## 🗂️ 1. Struktur Proyek

```
website-sendy/
├── public/                     ← Semua yang dilihat pengunjung
│   ├── index.html               (halaman utama)
│   ├── admin.html                (halaman admin, tersembunyi)
│   ├── css/
│   │   ├── style.css             (tampilan halaman utama)
│   │   └── admin.css             (tampilan halaman admin)
│   └── js/
│       ├── app.js                (logika halaman utama)
│       └── admin.js              (logika halaman admin)
├── netlify/
│   └── functions/               ← "Backend" yang jalan otomatis di Netlify
│       ├── utils.js              (fungsi bantu bersama)
│       ├── log-visit.js          (mencatat nama & jawaban pengunjung)
│       ├── admin-login.js        (cek username/password admin)
│       └── get-visitors.js       (mengambil data untuk dashboard admin)
├── netlify.toml                 (konfigurasi deploy Netlify)
├── package.json
├── .env.example                 (contoh isian environment variables)
├── supabase-schema.sql          (perintah untuk membuat tabel database)
└── README.md                    (file ini)
```

Kamu **tidak perlu** proses build (tidak ada React/Vite). Ini murni HTML, CSS,
dan JavaScript biasa, jadi mudah dibuka dan diubah kapan saja.

---

## 🧱 2. Membuat Database di Supabase (gratis)

Supabase dipakai untuk menyimpan data pengunjung supaya bisa dilihat dari
perangkat manapun (tidak hanya localStorage di satu HP/browser).

1. Buka **https://supabase.com** → **Start your project** → daftar/masuk
   (bisa pakai akun GitHub/Google).
2. Klik **New Project**.
   - Isi nama project bebas, misalnya `website-sendy`.
   - Buat password database (simpan baik-baik, tapi ini beda dengan
     password admin website kamu).
   - Pilih region terdekat (misalnya Singapore).
   - Klik **Create new project** dan tunggu 1–2 menit sampai siap.
3. Setelah project siap, buka menu **SQL Editor** di sidebar kiri.
4. Klik **New query**, lalu buka file `supabase-schema.sql` dari proyek ini,
   salin semua isinya, tempel ke SQL Editor, lalu klik **Run**.
   - Ini akan membuat tabel bernama `visitors` untuk menyimpan data
     pengunjung, sekaligus mengunci tabel itu agar tidak bisa diakses
     sembarangan dari luar.
5. Buka menu **Project Settings** (ikon gerigi) → **API**.
   - Salin nilai **Project URL** → ini nanti jadi `SUPABASE_URL`.
   - Salin nilai **service_role key** (di bagian "Project API keys") →
     ini nanti jadi `SUPABASE_SERVICE_KEY`.
   - ⚠️ **service_role key ini sangat rahasia** — jangan pernah taruh di
     kode frontend atau bagikan ke orang lain. Kita hanya akan
     menaruhnya di environment variable Netlify (lihat langkah 4).

---

## 🔑 3. Menentukan Username, Password Admin, dan Kunci Rahasia

Buka file `.env.example`, kamu akan lihat 5 nilai yang perlu diisi nanti di
Netlify (bukan di file ini, karena file ini bukan tempat rahasia):

| Nama Variabel         | Isi dengan                                                   |
|------------------------|---------------------------------------------------------------|
| `SUPABASE_URL`         | Project URL dari Supabase (langkah 2.5)                       |
| `SUPABASE_SERVICE_KEY` | service_role key dari Supabase (langkah 2.5)                  |
| `ADMIN_USERNAME`       | Username untuk login ke `/admin`, bebas kamu tentukan          |
| `ADMIN_PASSWORD`       | Password untuk login ke `/admin`, **ganti dari contoh default**|
| `ADMIN_TOKEN_SECRET`   | Teks acak & panjang (minimal 32 karakter), bebas, untuk keamanan sesi login |

Untuk `ADMIN_TOKEN_SECRET`, kamu bisa gunakan kalimat acak sepanjang mungkin,
misalnya: `rahasia-sendy-2026-jangan-disebar-abcdef123456`.

---

## 🚀 4. Deploy ke Netlify

### Cara termudah (drag & drop folder + Git — direkomendasikan)

1. Buat akun di **https://netlify.com** (gratis).
2. Unggah folder proyek ini ke GitHub terlebih dahulu:
   - Buat repository baru di GitHub.
   - Upload seluruh isi folder `website-sendy/` ke repository tersebut.
3. Di Netlify, klik **Add new site** → **Import an existing project** →
   pilih GitHub → pilih repository yang tadi kamu buat.
4. Pada pengaturan build:
   - **Build command**: kosongkan saja
   - **Publish directory**: `public`
   - (File `netlify.toml` sudah mengatur folder `functions` secara otomatis)
5. Klik **Deploy site**. Tunggu proses selesai.

### Mengisi Environment Variables di Netlify

1. Di dashboard site kamu, buka **Site configuration** → **Environment
   variables**.
2. Klik **Add a variable** untuk masing-masing dari 5 variabel di tabel
   pada Bagian 3 (`SUPABASE_URL`, `SUPABASE_SERVICE_KEY`, `ADMIN_USERNAME`,
   `ADMIN_PASSWORD`, `ADMIN_TOKEN_SECRET`).
3. Setelah semua ditambahkan, buka tab **Deploys** → klik **Trigger deploy**
   → **Deploy site** supaya environment variables terbaca oleh fungsi
   backend.

Setelah selesai, website kamu bisa diakses di alamat seperti
`https://nama-site-kamu.netlify.app`, dan halaman admin ada di
`https://nama-site-kamu.netlify.app/admin`.

---

## 💻 5. Menjalankan di Komputer Sendiri (opsional, untuk uji coba)

Karena ada backend (Netlify Functions), membuka `index.html` langsung di
browser tidak akan membuat fitur pencatatan pengunjung berjalan. Gunakan
Netlify CLI:

```bash
npm install -g netlify-cli
cd website-sendy
netlify dev
```

Buat file `.env` (salin dari `.env.example`, isi dengan nilai asli kamu),
lalu `netlify dev` akan otomatis membacanya. Buka alamat yang muncul di
terminal (biasanya `http://localhost:8888`).

---

## ✏️ 6. Mengubah Teks & Desain di Kemudian Hari

- **Teks halaman utama**: buka `public/index.html` — semua tulisan seperti
  "HALO! 👋" atau "APAKAH HARI INI KAMU BAHAGIA? 😊" ada langsung di dalam
  file ini, tinggal diketik ulang.
- **Pesan setelah menjawab**: buka `public/js/app.js`, cari bagian
  `const RESPONS = { ... }` — di situ ada 3 jawaban (`bahagia`, `sedikit`,
  `belum`) beserta emoji, judul, dan teksnya.
- **Warna & tampilan**: buka `public/css/style.css`, di bagian paling atas
  ada `:root { --pink-utama: ...; }` — ubah kode warna di situ untuk
  mengganti tema warna seluruh halaman utama. Untuk halaman admin, ubah di
  `public/css/admin.css`.
- **Watermark**: teks "Sendy 💗" ada di `public/index.html` (tag
  `<footer class="watermark">`) dan `public/admin.html`.
- **Mengganti username/password admin**: cukup ubah nilai
  `ADMIN_USERNAME` dan `ADMIN_PASSWORD` di Netlify → Environment
  variables → lalu trigger deploy ulang. Tidak perlu mengubah kode sama
  sekali.

Setiap kali kamu mengubah file di GitHub, Netlify otomatis men-deploy ulang
website dalam waktu singkat.

---

## 🔐 7. Catatan Keamanan (penting dibaca)

- `SUPABASE_SERVICE_KEY`, `ADMIN_PASSWORD`, dan `ADMIN_TOKEN_SECRET` **hanya**
  disimpan sebagai environment variables di Netlify dan dipakai di dalam
  kode backend (`netlify/functions/`). Tidak ada satupun dari nilai ini yang
  dikirim ke browser pengunjung.
- Halaman `/admin` tidak akan menampilkan data apapun sebelum login berhasil.
  Token sesi login admin disimpan sementara di `sessionStorage` browser kamu
  dan otomatis kedaluwarsa setelah 12 jam.
- Tabel `visitors` di Supabase diaktifkan **Row Level Security** tanpa
  policy publik, sehingga tidak bisa diakses langsung dari luar — hanya
  lewat backend yang memakai service role key.
- Untuk keamanan maksimal, sebaiknya jangan bagikan link `/admin` ke siapa
  pun, dan gunakan password yang kuat & unik.

---

## 📱 8. Tentang Pengalaman Pengguna

- Website dirancang **mobile-first**: font, tombol, jarak, dan animasi akan
  menyesuaikan otomatis di HP, tablet, dan laptop/desktop.
- Animasi (bintang, hati, bunga, emoji melayang) dibuat seringan mungkin
  (hanya elemen CSS sederhana) supaya tetap cepat dibuka di HP dengan
  koneksi biasa.
- Semua elemen visual (ikon, animasi, tata letak) dibuat orisinal —
  terinspirasi dari nuansa lucu & romantis seperti pada referensi yang kamu
  berikan, tanpa menyalin aset berhak cipta apa pun.

---

Selamat! Website "Sendy 💗" kamu siap digunakan. Kalau ingin menambah fitur
lain di kemudian hari (misalnya pertanyaan tambahan, tema warna baru, atau
efek animasi lain), tinggal ubah file-file di atas sesuai panduan Bagian 6. 🌸
