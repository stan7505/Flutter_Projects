import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../Database/habit_database.dart';
import '../models/habit.dart';
import '../util/habit_util.dart';
import '../util/myheatmap.dart';
import 'Theme/themeswitch.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState(){
    Provider.of<HabitDatabase>(context,listen: false).readHabits();
    super.initState();
  }

  TextEditingController  addhabitcontroller = TextEditingController();
  TextEditingController  updatehabitcontroller = TextEditingController();

/** C **/
  void AddHabit(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Add Habit"),
          content: TextField(
            controller: addhabitcontroller,
            decoration:  const InputDecoration(
              hintText: "Create a new Habit",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: (){
                if(addhabitcontroller.text.isNotEmpty){
                  Provider.of<HabitDatabase>(context,listen: false).addHabit(addhabitcontroller.text);
                  addhabitcontroller.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      }
    );

  }
/** U **/
  void UpdateHabitname(Habit habit){
    updatehabitcontroller.text = habit.name;
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Update Habit"),
          content: TextField(
            controller: updatehabitcontroller,
            decoration:  const InputDecoration(
              hintText: "Update Habit",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: (){
                if(updatehabitcontroller.text.isNotEmpty){
                  Provider.of<HabitDatabase>(context,listen: false).UpdateHabitName(habit.id,updatehabitcontroller.text);
                  updatehabitcontroller.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      }
    );
  }
/** D **/
  void DeleteHabit(Habit habit){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Delete Habit"),
          content: Text("Are you sure you want to delete ${habit.name}"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: (){
                Provider.of<HabitDatabase>(context,listen: false).deleteHabit(habit.id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      }
    );
  }
/** R **/
  Widget _buildhabitlist(){
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currenthabits = habitDatabase.currenthabits;
    return ListView.builder(
      itemCount: currenthabits.length,
      itemBuilder: (context,index){
        bool isCompletedToday = isHabitCompletedToday(currenthabits[index].completedDates);
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Slidable(
            endActionPane:
            ActionPane(

              extentRatio: 0.5,
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  spacing: 5,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (context){
                    UpdateHabitname(currenthabits[index]);
                  },
                  icon: Icons.edit,
                  backgroundColor: Colors.grey[400]!,
                ),
                SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (context){
                    DeleteHabit(currenthabits[index]);
                  },
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade200,
                ),
              ],
            ),
            child: GestureDetector(
                onTap:  (){
                  habitDatabase.updatehabit(currenthabits[index].id,!isCompletedToday);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCompletedToday ? Colors.green[500] : Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currenthabits[index].name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey[300]),),
                      Icon(isCompletedToday ? Icons.check_circle : Icons.radio_button_unchecked,color: Colors.black,size: 30,)
                    ],
                  ),
                )
            ),
          ),
        );
      },
    );

  }

  Widget _buildheatmap(){
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currenthabits = habitDatabase.currenthabits;
    return FutureBuilder<DateTime?>(
        future: HabitDatabase().getFirstLaunchDate(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Myheatmap(
              startdate: snapshot.data!,
              data: getHabitData(currenthabits),
            );
          }
          else
            return Container();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: AddHabit,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        title:  Text("Habit Tracker",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.grey[300]),),
      ),
      drawer: Drawer(
        child: Center(child: Themeswitch())
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          _buildheatmap(),
          SizedBox(height: 20,),
          Expanded(child: _buildhabitlist()),
        ],
      ),
    );
  }
}
