import 'package:flutter/material.dart';

/// Background/foreground pair used by status chips and badges.
@immutable
class StatusTone {
  const StatusTone({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  static StatusTone lerp(StatusTone a, StatusTone b, double t) => StatusTone(
    background: Color.lerp(a.background, b.background, t)!,
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
  );
}

/// Semantic colors for each application status, with light and dark variants.
///
/// Widgets must read these through `context.statusColors` rather than
/// hardcoding colors. Always pair a status color with an icon or label so
/// the status is not communicated by color alone.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.saved,
    required this.applied,
    required this.screening,
    required this.interview,
    required this.technicalTest,
    required this.offer,
    required this.rejected,
    required this.withdrawn,
  });

  final StatusTone saved;
  final StatusTone applied;
  final StatusTone screening;
  final StatusTone interview;
  final StatusTone technicalTest;
  final StatusTone offer;
  final StatusTone rejected;
  final StatusTone withdrawn;

  List<StatusTone> get all => [
    saved,
    applied,
    screening,
    interview,
    technicalTest,
    offer,
    rejected,
    withdrawn,
  ];

  static const StatusColors light = StatusColors(
    saved: StatusTone(
      background: Color(0xFFECEEF1),
      foreground: Color(0xFF4A5261),
    ),
    applied: StatusTone(
      background: Color(0xFFE3ECFD),
      foreground: Color(0xFF1E4FB8),
    ),
    screening: StatusTone(
      background: Color(0xFFDDF3F1),
      foreground: Color(0xFF0F6B63),
    ),
    interview: StatusTone(
      background: Color(0xFFEDE7FC),
      foreground: Color(0xFF5B3CC4),
    ),
    technicalTest: StatusTone(
      background: Color(0xFFFDF0D9),
      foreground: Color(0xFF8A5A00),
    ),
    offer: StatusTone(
      background: Color(0xFFDFF5E6),
      foreground: Color(0xFF1C7A3F),
    ),
    rejected: StatusTone(
      background: Color(0xFFFBE4E4),
      foreground: Color(0xFFB3261E),
    ),
    withdrawn: StatusTone(
      background: Color(0xFFEFEBE7),
      foreground: Color(0xFF6B5E53),
    ),
  );

  static const StatusColors dark = StatusColors(
    saved: StatusTone(
      background: Color(0xFF2A2F37),
      foreground: Color(0xFFC3C9D4),
    ),
    applied: StatusTone(
      background: Color(0xFF1B2C4D),
      foreground: Color(0xFFA9C4FA),
    ),
    screening: StatusTone(
      background: Color(0xFF14332F),
      foreground: Color(0xFF8ED8CE),
    ),
    interview: StatusTone(
      background: Color(0xFF2A2250),
      foreground: Color(0xFFC9B8FA),
    ),
    technicalTest: StatusTone(
      background: Color(0xFF3A2D12),
      foreground: Color(0xFFF2C77A),
    ),
    offer: StatusTone(
      background: Color(0xFF15331F),
      foreground: Color(0xFF93D9A9),
    ),
    rejected: StatusTone(
      background: Color(0xFF3D1C1B),
      foreground: Color(0xFFF4AAA4),
    ),
    withdrawn: StatusTone(
      background: Color(0xFF332C27),
      foreground: Color(0xFFD2C4B8),
    ),
  );

  @override
  StatusColors copyWith({
    StatusTone? saved,
    StatusTone? applied,
    StatusTone? screening,
    StatusTone? interview,
    StatusTone? technicalTest,
    StatusTone? offer,
    StatusTone? rejected,
    StatusTone? withdrawn,
  }) => StatusColors(
    saved: saved ?? this.saved,
    applied: applied ?? this.applied,
    screening: screening ?? this.screening,
    interview: interview ?? this.interview,
    technicalTest: technicalTest ?? this.technicalTest,
    offer: offer ?? this.offer,
    rejected: rejected ?? this.rejected,
    withdrawn: withdrawn ?? this.withdrawn,
  );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      saved: StatusTone.lerp(saved, other.saved, t),
      applied: StatusTone.lerp(applied, other.applied, t),
      screening: StatusTone.lerp(screening, other.screening, t),
      interview: StatusTone.lerp(interview, other.interview, t),
      technicalTest: StatusTone.lerp(technicalTest, other.technicalTest, t),
      offer: StatusTone.lerp(offer, other.offer, t),
      rejected: StatusTone.lerp(rejected, other.rejected, t),
      withdrawn: StatusTone.lerp(withdrawn, other.withdrawn, t),
    );
  }
}
