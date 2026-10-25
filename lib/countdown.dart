class CountdownRemaining {
  const CountdownRemaining({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isPast,
  });

  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isPast;
}

class Countdown {
  Countdown(this.targetDate);

  final DateTime targetDate;

  CountdownRemaining remainingAt(DateTime now) {
    final difference = targetDate.difference(now);
    if (difference.isNegative) {
      return const CountdownRemaining(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        isPast: true,
      );
    }

    return CountdownRemaining(
      days: difference.inDays,
      hours: difference.inHours.remainder(24),
      minutes: difference.inMinutes.remainder(60),
      seconds: difference.inSeconds.remainder(60),
      isPast: false,
    );
  }
}
