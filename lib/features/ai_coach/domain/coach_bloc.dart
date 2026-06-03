import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';

sealed class CoachEvent {}
final class CoachStarted extends CoachEvent {}
final class CoachMessageSent extends CoachEvent {
  final String text;
  CoachMessageSent(this.text);
}
final class CoachCleared extends CoachEvent {}

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
  final List<DisplayMessage> messages;
  final bool isGenerating;
  final String? errorMessage;

  const CoachState({
    this.messages = const [],
    this.isGenerating = false,
    this.errorMessage,
  });

  CoachState copyWith({
    List<DisplayMessage>? messages,
    bool? isGenerating,
    String? errorMessage,
  }) => CoachState(
    messages: messages ?? this.messages,
    isGenerating: isGenerating ?? this.isGenerating,
    errorMessage: errorMessage,
  );
}

abstract class CoachRepository {
  Stream<ConversationEvent> get events;
  SurfaceController get controller;
  Future<void> startConversation();
  Future<void> sendMessage(String text);
  void dispose();
}

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository repository;

  CoachBloc({required this.repository}) : super(const CoachState()) {
    on<CoachStarted>(_onStarted);
    on<CoachMessageSent>(_onMessageSent);
    on<CoachCleared>(_onCleared);
  }

  Future<void> _onStarted(CoachStarted _, Emitter<CoachState> emit) async {
    await repository.startConversation();
    await emit.forEach(repository.events, onData: (event) {
      return switch (event) {
        ConversationSurfaceAdded(:final surfaceId) => state.copyWith(
            messages: [...state.messages, AiSurfaceMessage(surfaceId)],
            isGenerating: false),
        _ => state.copyWith(isGenerating: false),
      };
    });
  }

  Future<void> _onMessageSent(CoachMessageSent event, Emitter<CoachState> emit) async {
    emit(state.copyWith(
      messages: [...state.messages, UserMessage(event.text)],
      isGenerating: true,
    ));
    await repository.sendMessage(event.text);
  }

  void _onCleared(CoachCleared _, Emitter<CoachState> emit) {
    emit(const CoachState());
    repository.startConversation();
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}
