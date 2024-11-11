import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Database/habit_database.dart';
import 'Pages/Theme/themes.dart';
import 'Pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const Homepage(),
    );
  }
}