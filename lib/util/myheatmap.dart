import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class Myheatmap extends StatefulWidget {

  Map<DateTime,int>? data;
  final DateTime startdate;

   Myheatmap({super.key,
    required this.data,
    required this.startdate,});

  @override
  State<Myheatmap> createState() => _MyheatmapState();
}

class _MyheatmapState extends State<Myheatmap> {
  @override
  Widget build(BuildContext context) {
    return  HeatMap(
      datasets: widget.data,
        startDate: widget.startdate,
        endDate: DateTime.now(),
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.secondary,
        colorsets: {
          1: Colors.orange.shade200,
          2: Colors.orange.shade300,
          3: Colors.orange.shade400,
          4: Colors.orange.shade500,
          5: Colors.orange.shade900,
        }

    );
  }
}
