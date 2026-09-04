/// A calendar date with no time-of-day or timezone component.
///
/// Habit occurrence dates are stored and reasoned about as local calendar
/// dates (docs/DATA_MODEL.md), independent of UTC rollover or DST. Internal
/// arithmetic uses [DateTime.utc] so day-difference/addition math is never
/// perturbed by a DST transition in the device's local timezone.
class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;

  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Parses a 'YYYY-MM-DD' string as stored in the database.
  factory LocalDate.parse(String value) {
    final parts = value.split('-');
    return LocalDate(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  DateTime _asUtc() => DateTime.utc(year, month, day);

  /// ISO weekday: 1 = Monday .. 7 = Sunday.
  int get weekday => _asUtc().weekday;

  LocalDate addDays(int days) => LocalDate.fromDateTime(_asUtc().add(Duration(days: days)));

  int differenceInDays(LocalDate other) => _asUtc().difference(other._asUtc()).inDays;

  bool isBefore(LocalDate other) => _asUtc().isBefore(other._asUtc());

  bool isAfter(LocalDate other) => _asUtc().isAfter(other._asUtc());

  bool isOnOrBefore(LocalDate other) => this == other || isBefore(other);

  bool isOnOrAfter(LocalDate other) => this == other || isAfter(other);

  @override
  int compareTo(LocalDate other) => _asUtc().compareTo(other._asUtc());

  @override
  bool operator ==(Object other) =>
      other is LocalDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
