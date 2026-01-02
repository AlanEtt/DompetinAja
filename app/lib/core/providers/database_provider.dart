import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/app_database.dart' as drift;
import '../database/seed_data.dart';

part 'database_provider.g.dart';

@riverpod
drift.AppDatabase appDatabase(AppDatabaseRef ref) {
  final database = drift.AppDatabase();
  // Seed default data on first run (async, but we can't await in provider)
  seedDefaultData(database).catchError((error) {
    // Ignore errors during seeding
  });
  return database;
}

