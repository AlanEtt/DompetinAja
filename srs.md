# Software Requirements Specification (SRS) - DompetinAja

Dokumen ini merinci kebutuhan fungsional dan non-fungsional dari sistem.

## 1. Kebutuhan Fungsional

### F1: Manajemen Dompet/Akun
- **F1.1:** Sistem harus menyediakan antarmuka untuk membuat, membaca, memperbarui, dan menghapus (CRUD) dompet.
- **F1.2:** Setiap dompet harus memiliki nama dan saldo awal.
- **F1.3:** Saldo setiap dompet harus diperbarui secara otomatis setiap kali ada transaksi yang terkait dengannya.
- **F1.4:** Sistem harus menampilkan total saldo dari semua dompet di halaman utama.

### F2: Manajemen Transaksi
- **F2.1:** Sistem harus memungkinkan pengguna melakukan CRUD pada transaksi pemasukan dan pengeluaran.
- **F2.2:** Saat membuat transaksi, pengguna harus mengisi jumlah, memilih dompet, memilih kategori, dan tanggal. Deskripsi bersifat opsional.
- **F2.3:** Sistem harus menampilkan daftar riwayat transaksi, diurutkan dari yang terbaru.
- **F2.4:** Sistem harus menyediakan fungsi filter pada riwayat transaksi berdasarkan rentang tanggal, dompet, dan/atau kategori.

### F3: Manajemen Kategori
- **F3.1:** Sistem harus memungkinkan pengguna melakukan CRUD pada kategori.
- **F3.2:** Setiap kategori harus memiliki nama dan tipe (Pemasukan atau Pengeluaran).
- **F3.3:** Sistem harus melarang penghapusan kategori jika masih ada transaksi yang menggunakannya.

### F4: Perencanaan Anggaran (Budgeting)
- **F4.1:** Sistem harus memungkinkan pengguna untuk menetapkan anggaran bulanan untuk setiap kategori pengeluaran.
- **F4.2:** Sistem harus menampilkan ringkasan penggunaan anggaran (misal: "Rp 500.000 / Rp 1.000.000") untuk setiap kategori yang dianggarkan.
- **F4.3:** Sistem harus memberikan peringatan visual (misal: bar progres berubah warna) jika penggunaan anggaran mendekati atau melebihi batas.

### F5: Pencatatan Utang/Piutang
- **F5.1:** Sistem harus menyediakan antarmuka untuk CRUD utang dan piutang.
- **F5.2:** Pengguna harus bisa menandai utang/piutang sebagai "lunas".
- **F5.3:** Saat ditandai lunas, sistem harus menawarkan untuk membuat transaksi pemasukan/pengeluaran yang sesuai secara otomatis.

### F6: Transaksi Berulang
- **F6.1:** Sistem harus memungkinkan pengguna untuk mengatur transaksi yang akan dibuat secara otomatis pada frekuensi tertentu (harian, mingguan, bulanan).
- **F6.2:** Sistem harus memiliki mekanisme untuk memeriksa dan membuat transaksi ini pada tanggal yang seharusnya.

### F7: Laporan & Visualisasi
- **F7.1:** Halaman utama (dashboard) harus menampilkan diagram lingkaran (pie chart) yang menunjukkan persentase pengeluaran berdasarkan kategori untuk bulan berjalan.
- **F7.2:** Dashboard juga harus menampilkan diagram batang (bar chart) yang membandingkan total pemasukan dan pengeluaran selama 6 bulan terakhir.

### F8: Ekspor Data
- **F8.1:** Sistem harus memiliki fungsi untuk mengekspor seluruh riwayat transaksi ke dalam file berformat CSV.

## 2. Kebutuhan Non-Fungsional

- **NF1:** Performa: Waktu buka aplikasi (cold start) harus kurang dari 3 detik. Navigasi antar layar harus terasa instan dengan animasi yang mulus (60 FPS).
- **NF2:** Usabilitas: Antarmuka harus bersih, modern, dan konsisten. Alur kerja untuk tugas-tugas umum (seperti menambah transaksi) harus singkat dan intuitif.
- **NF3:** Keandalan: Aplikasi harus dapat menangani kondisi tanpa koneksi internet (berfungsi penuh secara offline). Data tidak boleh hilang atau rusak jika aplikasi ditutup secara paksa.
- **NF4:** Penyimpanan: Semua data pengguna harus disimpan secara lokal di database SQLite dalam direktori privat aplikasi.
- **NF5:** Kompatibilitas: Aplikasi harus mendukung Android 6.0 (Marshmallow) ke atas dan iOS 12.0 ke atas.
- **NF6:** Keamanan: Data sensitif yang disimpan di perangkat harus dienkripsi jika memungkinkan.
- **NF7:** Skalabilitas: Arsitektur harus dirancang sedemikian rupa sehingga memungkinkan penambahan fitur sinkronisasi cloud di masa depan tanpa merombak total basis kode.