/// User's preferred clock format (BRD §S03/§16). `system` defers to the
/// device locale's default.
enum AppTimeFormat {
  system,
  h12,
  h24;

  static AppTimeFormat fromString(String value) {
    switch (value.toLowerCase()) {
      case 'h12':
        return AppTimeFormat.h12;
      case 'h24':
        return AppTimeFormat.h24;
      case 'system':
        return AppTimeFormat.system;
      default:
        return AppTimeFormat.system;
    }
  }

  String toStringValue() => name;
}
