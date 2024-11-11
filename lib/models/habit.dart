import 'package:isar/isar.dart';
part 'habit.g.dart';



@Collection()
class Habit{

  Id id = Isar.autoIncrement;
  late String name;

  List<DateTime> completedDates = [];
}


@Collection()
class AppSettings{
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
