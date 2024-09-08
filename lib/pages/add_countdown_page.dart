import 'package:flutter/material.dart';

class AddCountdownPage extends StatefulWidget {
  @override
  _AddCountdownPageState createState() => _AddCountdownPageState();
}

class _AddCountdownPageState extends State<AddCountdownPage> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = "";
  DateTime? _eventDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Countdown'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _eventDate = pickedDate;
                    });
                  }
                },
                child: Text('Pick Event Date'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _eventDate != null) {
                    _formKey.currentState!.save();
                    // Pass the event data back to the home page
                    Navigator.pop(context,
                        {'description': _eventName, 'date': _eventDate});
                  }
                },
                child: Text('Save Countdown'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
