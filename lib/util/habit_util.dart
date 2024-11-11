import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDates) {
  final today = DateTime.now();
  return completedDates.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}


Map <DateTime,int> getHabitData(List<Habit> habits){
  Map<DateTime,int> data = {};
  for(var habit in habits){
    for(var date in habit.completedDates){

      final normalizedDate = DateTime(date.year,date.month,date.day);
      if(data.containsKey(normalizedDate)){
        data[normalizedDate] = data[normalizedDate]! + 1;
      }else{
        data[normalizedDate] = 1;
      }
    }
  }
  return data;
}