import 'package:flutter/material.dart';

import 'home_page.dart';

class AddCountdownPage extends StatefulWidget {
  const AddCountdownPage({super.key});

  @override
  State<AddCountdownPage> createState() => _AddCountdownPageState();
}

class _AddCountdownPageState extends State<AddCountdownPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _eventDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDate ?? now),
    );
    if (!mounted) return;
    final time = pickedTime ?? const TimeOfDay(hour: 9, minute: 0);
    setState(() {
      _eventDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _eventDate == null) {
      if (_eventDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pick a date for this event')),
        );
      }
      return;
    }
    Navigator.pop(context, {
      'description': _nameController.text.trim(),
      'date': _eventDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New event')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(color: Color(0xFFF4F1EA), fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Event name',
                  labelStyle: TextStyle(color: Color(0xFFA7B0C0)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _pickDate,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  foregroundColor: const Color(0xFFF4F1EA),
                  side: const BorderSide(color: Color(0xFF2A3142)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _eventDate == null
                      ? 'Pick date and time'
                      : formatEventDate(_eventDate!),
                ),
              ),
              const Spacer(),
              FilledButton(onPressed: _save, child: const Text('Save event')),
            ],
          ),
        ),
      ),
    );
  }
}
