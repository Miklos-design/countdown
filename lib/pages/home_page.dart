import 'dart:async';

import 'package:flutter/material.dart';

import '../countdown.dart';
import 'add_countdown_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _cream = Color(0xFFF4F1EA);
  static const _muted = Color(0xFFA7B0C0);

  late List<Map<String, dynamic>> events;
  late Timer _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    final today = DateTime(_now.year, _now.month, _now.day);
    events = [
      {
        'description': 'City break',
        'date': today.add(const Duration(days: 6, hours: 9)),
      },
      {
        'description': 'Birthday dinner',
        'date': today.add(const Duration(days: 24, hours: 19)),
      },
      {
        'description': 'New Year',
        'date': DateTime(_now.year + 1, 1, 1),
      },
    ];
    _sortEvents();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _sortEvents() {
    events.sort(
      (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
    );
  }

  Future<void> _openAdd() async {
    final newEvent = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddCountdownPage()),
    );
    if (newEvent == null) return;
    setState(() {
      events.add(newEvent);
      _sortEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final next = events.first;
    final rest = events.skip(1);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Countdown',
                        style: TextStyle(
                          color: _cream,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'What you are waiting for',
                        style: TextStyle(color: _muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined, color: _cream),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FeaturedEvent(
              name: next['description'] as String,
              date: next['date'] as DateTime,
              now: _now,
            ),
            const SizedBox(height: 22),
            const Text(
              'Also coming up',
              style: TextStyle(
                color: _muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 10),
            for (final event in rest) ...[
              _EventRow(
                name: event['description'] as String,
                date: event['date'] as DateTime,
                now: _now,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: FilledButton.icon(
            onPressed: _openAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add event'),
          ),
        ),
      ),
    );
  }
}

class _FeaturedEvent extends StatelessWidget {
  const _FeaturedEvent({
    required this.name,
    required this.date,
    required this.now,
  });

  final String name;
  final DateTime date;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final remaining = Countdown(date).remainingAt(now);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2418), Color(0xFF1C2230)],
        ),
        border: Border.all(color: const Color(0x33E7B15A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEXT UP',
            style: TextStyle(
              color: Color(0xFFE7B15A),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFFF4F1EA),
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatEventDate(date),
            style: const TextStyle(color: Color(0xFFA7B0C0), fontSize: 14),
          ),
          const SizedBox(height: 22),
          if (remaining.isPast)
            const Text(
              'This event has passed',
              style: TextStyle(color: Color(0xFFF4F1EA), fontSize: 18),
            )
          else
            Row(
              children: [
                _TimeBlock(value: '${remaining.days}', label: 'Days'),
                _TimeBlock(
                  value: _two(remaining.hours),
                  label: 'Hours',
                ),
                _TimeBlock(
                  value: _two(remaining.minutes),
                  label: 'Min',
                ),
                _TimeBlock(
                  value: _two(remaining.seconds),
                  label: 'Sec',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF4F1EA),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFA7B0C0),
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.name,
    required this.date,
    required this.now,
  });

  final String name;
  final DateTime date;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final remaining = Countdown(date).remainingAt(now);
    final summary = remaining.isPast
        ? 'Passed'
        : '${remaining.days}d  ${_two(remaining.hours)}h  ${_two(remaining.minutes)}m';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2230),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF2A3142),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.hourglass_bottom_rounded,
              color: Color(0xFFE7B15A),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFF4F1EA),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatEventDate(date),
                  style: const TextStyle(color: Color(0xFFA7B0C0), fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            summary,
            style: const TextStyle(
              color: Color(0xFFE7B15A),
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

String formatEventDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${months[date.month - 1]} ${date.year} · $hour:$minute';
}

String _two(int value) => value.toString().padLeft(2, '0');
