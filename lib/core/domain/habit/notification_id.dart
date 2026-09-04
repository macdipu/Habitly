/// Deterministic 31-bit id for a (habitId, reminderId) pair, stable across
/// app restarts so a reminder can be cancelled later without persisting the
/// platform notification id anywhere (docs/SRS.md FR-50). FNV-1a — simple,
/// dependency-free, and stable across Dart versions (unlike `Object.hash`,
/// which is not guaranteed stable run-to-run).
int stableNotificationId(String habitId, String reminderId) {
  const fnvPrime = 0x01000193;
  var hash = 0x811c9dc5;
  for (final codeUnit in '$habitId|$reminderId'.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  // flutter_local_notifications ids are platform `int` (32-bit signed on
  // Android) — mask to 31 bits to always stay positive.
  return hash & 0x7FFFFFFF;
}
