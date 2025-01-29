class TimeFormat {
  String formatTime(DateTime time) {
    return '${addLeadingZero(time.hour)}:${addLeadingZero(time.minute)}';
  }

  String addLeadingZero(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
