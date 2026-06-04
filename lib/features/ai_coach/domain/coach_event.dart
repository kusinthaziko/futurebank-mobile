sealed class CoachEvent {}

final class CoachStarted extends CoachEvent {}

final class CoachMessageSent extends CoachEvent {
  final String text;
  CoachMessageSent(this.text);
}

final class CoachCleared extends CoachEvent {}

final class CoachPageChanged extends CoachEvent {
  final int index;
  CoachPageChanged(this.index);
}

final class CoachInternalWaiting extends CoachEvent {
  final bool isWaiting;
  CoachInternalWaiting(this.isWaiting);
}

final class CoachInternalText extends CoachEvent {
  final String text;
  CoachInternalText(this.text);
}

final class CoachInternalSurface extends CoachEvent {
  final String surfaceId;
  CoachInternalSurface(this.surfaceId);
}

final class CoachInternalError extends CoachEvent {
  final String message;
  CoachInternalError(this.message);
}
