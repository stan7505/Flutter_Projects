import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize the Isar instance
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first launch date
  Future<void> saveFirstLaunchDate() async {
    final existingsettings = await isar.appSettings.where().findFirst();
    if (existingsettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first launch date
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currenthabits =[];

// Add a new habit
  /** C **/
  Future<void> addHabit(String habit)async{
    final newhabit = Habit()..name = habit;
    await isar.writeTxn(() => isar.habits.put(newhabit));
    currenthabits.add(newhabit);
    readHabits();
  }

  // Read all habits
  /** R **/
  Future<void>readHabits()async{
    List<Habit> fetchedhabits = await isar.habits.where().findAll();
    currenthabits.clear();
    currenthabits.addAll(fetchedhabits);
    notifyListeners();
  }

  // Update habit completion status
  Future<void>updatehabit(int id,bool isCompleted)async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDates.contains(DateTime.now())) {
          final today = DateTime.now();

          habit.completedDates.add(
            DateTime(today.year, today.month, today.day),
          );

        } else   {
          habit.completedDates.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
              await isar.habits.put(habit);
      });
  }
    readHabits();
  }

// Update habit name
  /** U **/
  Future<void> UpdateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // Delete a habit
  /** D **/
  Future<void>deleteHabit(int id)async{
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }
}