sealed class CoachConversationEvent {}

final class CoachWaiting extends CoachConversationEvent {
  final bool isWaiting;
  CoachWaiting(this.isWaiting);
}

final class CoachTextReceived extends CoachConversationEvent {
  final String text;
  CoachTextReceived(this.text);
}

final class CoachSurfaceAdded extends CoachConversationEvent {
  final String surfaceId;
  CoachSurfaceAdded(this.surfaceId);
}

final class CoachError extends CoachConversationEvent {
  final String message;
  CoachError(this.message);
}
