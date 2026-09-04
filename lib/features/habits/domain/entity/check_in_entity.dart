import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';

/// User record resolving one scheduled occurrence. One per (habitId,
/// localDate) — repeated taps update the same entity (docs/SRS.md FR-33).
class CheckInEntity {
  final String id;
  final String habitId;
  final LocalDate localDate;
  final double? value;
  final CheckInStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CheckInEntity({
    required this.id,
    required this.habitId,
    required this.localDate,
    this.value,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
