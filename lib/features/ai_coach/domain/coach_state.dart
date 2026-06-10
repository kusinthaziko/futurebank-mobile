sealed class DisplayMessage {}

final class UserMessage extends DisplayMessage {
  final String text;
  UserMessage(this.text);
}

final class AiSurfaceMessage extends DisplayMessage {
  final String surfaceId;
  AiSurfaceMessage(this.surfaceId);
}

final class AiFallbackMessage extends DisplayMessage {
  final String text;
  AiFallbackMessage(this.text);
}

class CoachState {
  final List<List<DisplayMessage>> pages;
  final int currentPageIndex;
  final bool isGenerating;
  final String? errorMessage;
  final String? weeklyInsight;

  const CoachState({
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isGenerating = false,
    this.errorMessage,
    this.weeklyInsight,
  });

  List<DisplayMessage> get currentPageMessages =>
      pages.isNotEmpty ? pages[currentPageIndex] : [];

  List<DisplayMessage> get allMessages => pages.expand((p) => p).toList();

  CoachState copyWith({
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isGenerating,
    String? errorMessage,
    String? weeklyInsight,
    bool clearError = false,
    bool clearWeeklyInsight = false,
  }) => CoachState(
    pages: pages ?? this.pages,
    currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    isGenerating: isGenerating ?? this.isGenerating,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    weeklyInsight: clearWeeklyInsight
        ? null
        : (weeklyInsight ?? this.weeklyInsight),
  );
}
