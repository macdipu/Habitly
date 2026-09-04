/// Global quiet-hours window (BRD §S22, docs/SRS.md decision 6 —
/// suppress-only in MVP: a reminder due inside this window is either
/// dropped, or shifted to the window's end, never fired inside it).
class QuietHours {
  final bool enabled;

  /// 'HH:mm', inclusive start of the suppressed window.
  final String start;

  /// 'HH:mm', exclusive end of the suppressed window.
  final String end;

  const QuietHours({required this.enabled, required this.start, required this.end});

  static const QuietHours disabled = QuietHours(enabled: false, start: '22:00', end: '07:00');

  bool suppresses(String timeHHmm) {
    if (!enabled) return false;
    final t = _minutesOf(timeHHmm);
    final s = _minutesOf(start);
    final e = _minutesOf(end);
    if (s == e) return false; // zero-width window never suppresses
    if (s < e) return t >= s && t < e;
    return t >= s || t < e; // window wraps past midnight
  }

  static int _minutesOf(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
