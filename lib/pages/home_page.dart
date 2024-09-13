import 'package:flutter/material.dart';
import '../countdown.dart';
import 'add_countdown_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> events = [
    {"description": "Project Deadline", "date": DateTime(2024, 12, 31, 0, 0)},
    {"description": "Conference", "date": DateTime(2024, 11, 15, 9, 0)},
    {"description": "Birthday", "date": DateTime(2024, 10, 10, 0, 0)}
  ];

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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page (need birger instead?)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: events.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          final event = events[index];
          final countdown = Countdown(event['date']).calculateCountdown();

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event['description'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${countdown['days']} days and ${countdown['hours']} hours remaining',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCountdownPage()),
          );

          if (newEvent != null) {
            _addNewCountdown(newEvent['description'], newEvent['date']);
          }
        },
      ),
    );
  }
}
