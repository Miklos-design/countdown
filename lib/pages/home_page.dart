import 'package:flutter/material.dart';
import '../countdown.dart';
import 'add_countdown_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Hardcoded events, but you will allow dynamic adding
  List<Map<String, dynamic>> events = [
    {"description": "Project Deadline", "date": DateTime(2024, 12, 31, 0, 0)},
    {"description": "Conference", "date": DateTime(2024, 11, 15, 9, 0)},
    {"description": "Birthday", "date": DateTime(2024, 10, 10, 0, 0)}
  ];

  // Method to add new countdowns to the list
  void _addNewCountdown(String description, DateTime date) {
    setState(() {
      events.add({"description": description, "date": date});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdowns'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final countdown = Countdown(event['date']).calculateCountdown();

          return ListTile(
            title: Text(event['description']),
            subtitle: Text(
                '${countdown['days']} days and ${countdown['hours']} hours remaining'),
          );
        },
      ),
      // Add a floating action button to navigate to the AddCountdownPage
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Navigate to AddCountdownPage and wait for result
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCountdownPage()),
          );

          // If a new event is returned, add it to the events list
          if (newEvent != null) {
            _addNewCountdown(newEvent['description'], newEvent['date']);
          }
        },
      ),
    );
  }
}
