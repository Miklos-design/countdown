class Countdown {
  DateTime targetDate;

  Countdown(this.targetDate);

  Map<String, int> calculateCountdown() {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    return {
      'days': days,
      'hours': hours,
    };
  }
}
