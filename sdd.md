# Software Design Document (SDD) - DompetinAja

Dokumen ini menjelaskan "bagaimana" aplikasi akan dibangun, termasuk arsitektur, teknologi, dan desain komponen utama.

## 1. Arsitektur Perangkat Lunak

Aplikasi ini akan mengadopsi prinsip Clean Architecture yang terbagi menjadi tiga lapisan utama untuk memastikan pemisahan tanggung jawab (Separation of Concerns), kemudahan pengujian (testability), dan skalabilitas.

### Presentation Layer (UI & State Management)

**Komponen:** Widgets (Flutter), ViewModels/Controllers.

**Tanggung Jawab:** Menampilkan data ke pengguna dan menangkap input. Lapisan ini tidak akan berisi logika bisnis.

**Teknologi:**
- **Flutter:** Untuk membangun UI yang ekspresif dan native.
- **Riverpod (dengan Riverpod Generator):** Sebagai solusi state management. Widget akan me-listen providers untuk mendapatkan state dan akan di-rebuild saat state berubah. Generator digunakan untuk mengurangi boilerplate code.
- **Go_Router:** Untuk mengelola navigasi aplikasi secara deklaratif dan berbasis rute.

### Domain Layer (Business Logic)

**Komponen:** Use Cases (atau Services), Entitas/Model.

**Tanggung Jawab:** Berisi semua aturan dan logika bisnis inti aplikasi (e.g., cara menghitung sisa budget, validasi input). Lapisan ini tidak bergantung pada lapisan lain.

**Teknologi:**
- **Freezed:** Untuk membuat model data (entitas) yang immutable, aman, dan dilengkapi dengan utilitas seperti copyWith, toJson, dll.
- **fpdart:** Untuk menangani error dan alur data secara fungsional. Use cases akan mengembalikan Either<Failure, Success> untuk penanganan error yang eksplisit.

### Data Layer (Data Sources & Repository)

**Komponen:** Repositories, Data Sources (Lokal).

**Tanggung Jawab:** Mengelola sumber data. Repository menyediakan abstraksi (interface) yang akan digunakan oleh Domain Layer. Implementasi Repository akan berkomunikasi dengan Data Source untuk mengambil atau menyimpan data.

**Teknologi:**
- **Drift (Moor):** Sebagai reactive persistence library untuk SQLite. Drift akan menghasilkan kode Dart yang type-safe untuk semua query database berdasarkan skema yang kita definisikan. Sifat reaktifnya (Stream) akan terintegrasi sempurna dengan Riverpod.
- **Logger:** Untuk logging yang terstruktur selama pengembangan dan debugging.

## 2. Desain Database (Implementasi Drift)

Berdasarkan ERD, berikut adalah definisi tabel menggunakan Drift.

```dart
// lib/core/database/database.dart
import 'package:drift/drift.dart';

// Tabel untuk Dompet
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get initialBalance => integer().named('initial_balance')();
  IntColumn get iconCodePoint => integer().nullable().named('icon_code_point')();
}

// Tabel untuk Kategori
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get type => integer()(); // 0: expense, 1: income
  IntColumn get iconCodePoint => integer().nullable().named('icon_code_point')();
}

// Tabel untuk Transaksi
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
}

// Tabel untuk Budget
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  IntColumn get periodMonth => integer().named('period_month')();
  IntColumn get periodYear => integer().named('period_year')();
  
  @override
  List<String> get customConstraints => [
    'UNIQUE (category_id, period_month, period_year)'
  ];
}

// Tabel untuk Utang/Piutang
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get personName => text().named('person_name')();
  IntColumn get amount => integer()();
  IntColumn get type => integer()(); // 0: utang saya, 1: piutang saya
  DateTimeColumn get dueDate => dateTime().nullable().named('due_date')();
  BoolColumn get isSettled => boolean().named('is_settled').withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();
}

// Tabel untuk Transaksi Berulang
class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get frequency => text()(); // "daily", "weekly", "monthly"
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get nextOccurrenceDate => dateTime().named('next_occurrence_date')();
}
```

## 3. Desain Modul Kunci

### Modul Transaksi:
- **TransactionRepository** akan memiliki metode seperti `watchAllTransactions()`, `addTransaction(Transaction data)`, `deleteTransaction(int id)`.
- **TransactionNotifier** (Provider Riverpod) akan memanggil metode dari repository dan menyediakan data serta state (loading, error) ke UI.
- UI akan menggunakan `ConsumerWidget` atau `HookConsumerWidget` untuk listen ke provider dan menampilkan data.

### Modul Budgeting:
- **BudgetRepository** akan mengelola data anggaran.
- **BudgetProgressProvider** akan menjadi provider khusus (kemungkinan `FutureProvider` atau `StreamProvider`) yang mengambil data budget dan total pengeluaran untuk kategori terkait, lalu menghitung progresnya.
- UI akan menampilkan hasil dari provider ini dalam bentuk bar progres atau teks.

### Modul Transaksi Berulang:
- Sebuah **RecurringTransactionService** akan bertanggung jawab untuk logika penjadwalan.
- Mungkin menggunakan paket seperti `workmanager` untuk menjadwalkan tugas di latar belakang yang berjalan sekali sehari untuk memeriksa dan membuat transaksi yang jatuh tempo.

## 4. Alur Data (Contoh: Menambah Transaksi)

1. **UI:** Pengguna menekan tombol "Simpan" pada form tambah transaksi.
2. **Presentation:** `onPressed` memanggil method pada `TransactionNotifier`, misal: `addTransaction(formData)`.
3. **Presentation:** Notifier melakukan validasi, lalu memanggil UseCase dari Domain Layer.
4. **Domain:** `AddTransactionUseCase` dipanggil, yang kemudian memanggil method di `TransactionRepository` (interface).
5. **Data:** `TransactionRepositoryImpl` mengonversi model domain ke model Drift dan memanggil `database.addTransaction(driftData)`.
6. **Data:** Drift menyimpan data ke SQLite.
7. **Reaktif:** Stream dari Drift (yang di-listen oleh provider riwayat transaksi) otomatis memancarkan data baru.
8. **Presentation:** UI yang me-listen provider tersebut akan di-rebuild secara otomatis untuk menampilkan transaksi yang baru ditambahkan.