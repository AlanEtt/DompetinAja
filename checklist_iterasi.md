### Checklist Timeline Sprint MVP - DompetinAja (7 Minggu)
Rencana pengembangan ini dibagi menjadi 7 sprint mingguan, dengan fokus yang jelas untuk setiap sprint untuk membangun aplikasi secara iteratif.

#### Sprint 1: Fondasi Proyek & Data Inti (Minggu ke-1)
Tujuan: Menyiapkan seluruh fondasi teknis dan struktur database untuk fitur inti.

- [ ] Inisialisasi proyek Flutter baru.
- [ ] Tambahkan semua dependensi di pubspec.yaml (Riverpod Generator, Freezed, Drift, Go_Router, dll.).
- [ ] Buat struktur direktori proyek berdasarkan Clean Architecture (features, core, data, domain, presentation).
- [ ] Konfigurasi build_runner untuk code generation.
- [ ] Implementasikan skema database di Drift untuk tabel Wallets, Categories, dan Transactions.
- [ ] Buat Repository Interface di Domain Layer untuk ketiga entitas tersebut.
- [ ] Buat Repository Implementation di Data Layer yang menggunakan Drift untuk CRUD dasar.
- [ ] Tulis unit test sederhana untuk Repository untuk memastikan koneksi database berfungsi.

#### Sprint 2: Fungsionalitas Transaksi & Dompet (Minggu ke-2)
Tujuan: Memungkinkan pengguna untuk mengelola dompet dan mencatat transaksi dasar.

- [ ] Setup Go_Router dengan rute awal (home, add-transaction, manage-wallets).
- [ ] Buat UI untuk Manajemen Dompet (menampilkan daftar, menambah, mengedit).
- [ ] Buat UI untuk Form Tambah/Edit Transaksi, termasuk pilihan dompet dan kategori.
- [ ] Buat UI untuk Halaman Utama yang menampilkan daftar semua transaksi dari semua dompet.
- [ ] Hubungkan semua UI ke Provider Riverpod untuk mengelola state dan interaksi dengan repository.
- [ ] Pastikan saldo dompet dan total saldo diperbarui secara real-time saat transaksi ditambahkan/dihapus.

#### Sprint 3: Dashboard & Visualisasi Awal (Minggu ke-3)
Tujuan: Memberikan pengguna ringkasan visual dari kondisi keuangan mereka.

- [ ] Rancang dan bangun layout Dashboard utama.
- [ ] Buat provider Riverpod untuk menghitung metrik dashboard (Total Pemasukan, Total Pengeluaran, Saldo Akhir bulan ini).
- [ ] Integrasikan library chart (e.g., fl_chart).
- [ ] Implementasikan Pie Chart untuk menampilkan komposisi pengeluaran berdasarkan kategori.
- [ ] Implementasikan Bar Chart untuk menampilkan perbandingan pemasukan vs. pengeluaran selama beberapa bulan terakhir.
- [ ] Hubungkan chart ke data yang valid dari repository.

#### Sprint 4: Fitur Perencanaan Anggaran (Budgeting) (Minggu ke-4)
Tujuan: Mengimplementasikan fungsionalitas budgeting secara end-to-end.

- [ ] Implementasikan skema database di Drift untuk tabel Budgets.
- [ ] Buat UI untuk mengatur, melihat, dan menghapus budget bulanan per kategori.
- [ ] Buat provider Riverpod yang kompleks untuk menghitung progres penggunaan budget (total pengeluaran / budget yang ditetapkan).
- [ ] Tampilkan progres budget di halaman daftar budget atau di dashboard.
- [ ] Tambahkan indikator visual (misal: warna bar) untuk budget yang mendekati atau melebihi batas.

#### Sprint 5: Fitur Pencatatan Utang/Piutang (Minggu ke-5)
Tujuan: Memungkinkan pengguna melacak utang dan piutang.

- [ ] Implementasikan skema database di Drift untuk tabel Debts.
- [ ] Buat UI untuk CRUD Utang & Piutang.
- [ ] Implementasikan logika untuk mengubah status is_settled (lunas).
- [ ] Buat dialog konfirmasi saat menandai lunas, yang menawarkan untuk membuat transaksi terkait secara otomatis di dompet yang dipilih.
- [ ] Tampilkan daftar utang/piutang yang aktif di halaman terpisah.

#### Sprint 6: Fitur Lanjutan (Transaksi Berulang & Filter) (Minggu ke-6)
Tujuan: Menambahkan fitur otomatisasi dan meningkatkan kegunaan riwayat transaksi.

- [ ] Implementasikan skema database di Drift untuk tabel RecurringTransactions.
- [ ] Buat UI untuk mengatur transaksi berulang (frekuensi, tanggal mulai, dll.).
- [ ] Implementasikan service atau logika untuk mengeksekusi pembuatan transaksi berulang (bisa menggunakan workmanager atau pengecekan saat aplikasi dibuka).
- [ ] Bangun UI untuk filter lanjutan di halaman riwayat transaksi (filter berdasarkan dompet, kategori, rentang tanggal).
- [ ] Terapkan logika filter pada query Drift yang dipanggil oleh Riverpod.

#### Sprint 7: Finalisasi, Pengujian & Polish (Minggu ke-7)
Tujuan: Memastikan aplikasi stabil, bebas bug, dan siap untuk rilis MVP.

- [ ] Lakukan refactoring kode dan optimalkan performa di seluruh aplikasi.
- [ ] Poles UI/UX: perbaiki layout, tambahkan animasi halus, dan pastikan konsistensi desain.
- [ ] Implementasikan fitur Ekspor ke CSV.
- [ ] Lakukan pengujian manual secara menyeluruh di berbagai ukuran layar dan perangkat (Android & iOS).
- [ ] Perbaiki semua bug yang ditemukan selama pengujian.
- [ ] Siapkan aset aplikasi (ikon, splash screen).
- [ ] Buat build rilis (.apk dan .ipa) untuk distribusi internal atau rilis pertama.