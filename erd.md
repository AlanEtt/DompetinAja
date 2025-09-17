# Entity-Relationship Diagram (ERD) - DompetinAja

ERD ini mendefinisikan struktur database lokal yang akan digunakan oleh aplikasi. Relasi antar entitas dirancang untuk mendukung semua fitur yang direncanakan.

## Entitas

### Wallets (Dompet/Akun)

- `id`: INTEGER (Primary Key) - ID unik untuk setiap dompet.
- `name`: TEXT (Not Null) - Nama dompet (e.g., "Bank BCA", "Tunai").
- `initial_balance`: INTEGER (Not Null) - Saldo awal saat dompet dibuat.
- `icon_code_point`: INTEGER (Nullable) - Kode ikon untuk representasi visual.

### Categories (Kategori)

- `id`: INTEGER (Primary Key) - ID unik untuk setiap kategori.
- `name`: TEXT (Not Null) - Nama kategori (e.g., "Gaji", "Makanan").
- `type`: INTEGER (Not Null) - Jenis kategori (0: Pengeluaran, 1: Pemasukan).
- `icon_code_point`: INTEGER (Nullable) - Kode ikon.

### Transactions (Transaksi)

- `id`: INTEGER (Primary Key) - ID unik transaksi.
- `wallet_id`: INTEGER (Foreign Key -> Wallets.id) - Dompet asal transaksi.
- `category_id`: INTEGER (Foreign Key -> Categories.id) - Kategori transaksi.
- `amount`: INTEGER (Not Null) - Jumlah uang.
- `description`: TEXT (Nullable) - Catatan tambahan.
- `transaction_date`: DATETIME (Not Null) - Tanggal dan waktu transaksi.

### Budgets (Anggaran)

- `id`: INTEGER (Primary Key) - ID unik anggaran.
- `category_id`: INTEGER (Foreign Key -> Categories.id) - Kategori yang dianggarkan.
- `amount`: INTEGER (Not Null) - Jumlah anggaran yang ditetapkan.
- `period_month`: INTEGER (Not Null) - Bulan periode anggaran (1-12).
- `period_year`: INTEGER (Not Null) - Tahun periode anggaran.

### Debts (Utang/Piutang)

- `id`: INTEGER (Primary Key) - ID unik.
- `person_name`: TEXT (Not Null) - Nama orang yang terlibat.
- `amount`: INTEGER (Not Null) - Jumlah uang.
- `type`: INTEGER (Not Null) - Jenis (0: Utang saya, 1: Piutang saya).
- `due_date`: DATETIME (Nullable) - Tanggal jatuh tempo.
- `is_settled`: BOOLEAN (Not Null, Default: false) - Status lunas.
- `description`: TEXT (Nullable) - Catatan.

### RecurringTransactions (Transaksi Berulang)

- `id`: INTEGER (Primary Key) - ID unik.
- `wallet_id`: INTEGER (FK) - Dompet target.
- `category_id`: INTEGER (FK) - Kategori target.
- `amount`: INTEGER - Jumlah.
- `description`: TEXT - Deskripsi.
- `frequency`: TEXT (Not Null) - Frekuensi (e.g., "daily", "weekly", "monthly").
- `start_date`: DATETIME (Not Null) - Tanggal mulai.
- `next_occurrence_date`: DATETIME (Not Null) - Tanggal eksekusi berikutnya.

## Diagram Relasi Teks

```
[Wallets] 1--N [Transactions]
   |
   | 1--N [RecurringTransactions]
   |
[Categories] 1--N [Transactions]
   |
   | 1--N [Budgets]
   |
   | 1--N [RecurringTransactions]


[Debts] (Entitas mandiri, penyelesaiannya dapat memicu sebuah Transaksi baru)
```

- Satu Wallet memiliki banyak Transactions.
- Satu Category memiliki banyak Transactions.
- Satu Category dapat memiliki banyak Budgets (satu untuk setiap periode bulan/tahun).
- Relasi untuk RecurringTransactions mirip dengan Transactions.