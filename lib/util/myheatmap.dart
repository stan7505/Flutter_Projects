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
          1: Colors.green.shade200,
          2: Colors.green.shade300,
          3: Colors.green.shade400,
          4: Colors.green.shade500,
          5: Colors.green.shade600,
        }

    );
  }
}
