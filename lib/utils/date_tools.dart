class DateTools {
  static bool isAtLeast18YearsOld(DateTime birthDate) {
    DateTime today = DateTime.now();
    DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

    return birthDate.isBefore(eighteenYearsAgo) || birthDate.isAtSameMomentAs(eighteenYearsAgo);
  }

  DateTime getYearsAgo(int years) {
    if (years < 0) {
      throw ArgumentError('Years must be a positive number');
    }

    DateTime today = DateTime.now();
    return DateTime(today.year - years, today.month, today.day);
  }
}
