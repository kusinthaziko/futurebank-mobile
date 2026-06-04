import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_state.dart';
import 'coach_event.dart';
import 'coach_conversation_event.dart';

abstract class CoachRepository {
  Stream<CoachConversationEvent> get events;
  Future<void> startConversation();
  Future<void> sendMessage(String text);
  void dispose();
}

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository repository;
  StreamSubscription<CoachConversationEvent>? _eventSub;

  CoachBloc({required this.repository}) : super(const CoachState()) {
    on<CoachStarted>(_onStarted);
    on<CoachMessageSent>(_onMessageSent);
    on<CoachCleared>(_onCleared);
    on<CoachPageChanged>(_onPageChanged);
    on<CoachInternalWaiting>(_onInternalWaiting);
    on<CoachInternalText>(_onInternalText);
    on<CoachInternalSurface>(_onInternalSurface);
    on<CoachInternalError>(_onInternalError);
  }

  Future<void> _onStarted(CoachStarted _, Emitter<CoachState> emit) async {
    await repository.startConversation();
    _eventSub?.cancel();
    _eventSub = repository.events.listen((event) {
      if (!isClosed) add(_mapConversationEvent(event));
    });
  }

  CoachEvent _mapConversationEvent(CoachConversationEvent event) {
    return switch (event) {
      CoachWaiting(:final isWaiting) => CoachInternalWaiting(isWaiting),
      CoachTextReceived(:final text) => CoachInternalText(text),
      CoachSurfaceAdded(:final surfaceId) => CoachInternalSurface(surfaceId),
      CoachError(:final message) => CoachInternalError(message),
    };
  }

  Future<void> _onMessageSent(CoachMessageSent event, Emitter<CoachState> emit) async {
    final newPage = <DisplayMessage>[UserMessage(event.text)];
    emit(state.copyWith(
      pages: [...state.pages, newPage],
      currentPageIndex: state.pages.length,
      isGenerating: true,
      clearError: true,
    ));
    await repository.sendMessage(event.text);
  }

  void _onCleared(CoachCleared _, Emitter<CoachState> emit) {
    emit(const CoachState());
    repository.startConversation();
  }

  void _onPageChanged(CoachPageChanged event, Emitter<CoachState> emit) {
    emit(state.copyWith(currentPageIndex: event.index));
  }

  void _onInternalWaiting(CoachInternalWaiting event, Emitter<CoachState> emit) {
    emit(state.copyWith(isGenerating: event.isWaiting));
  }

  void _onInternalText(CoachInternalText event, Emitter<CoachState> emit) {
    final pages = [...state.pages];
    if (pages.isNotEmpty) {
      pages.last = [...pages.last, AiFallbackMessage(event.text)];
    }
    emit(state.copyWith(pages: pages, isGenerating: false));
  }

  void _onInternalSurface(CoachInternalSurface event, Emitter<CoachState> emit) {
    final pages = [...state.pages];
    if (pages.isNotEmpty) {
      pages.last = [...pages.last, AiSurfaceMessage(event.surfaceId)];
    }
    emit(state.copyWith(pages: pages, isGenerating: false));
  }

  void _onInternalError(CoachInternalError event, Emitter<CoachState> emit) {
    emit(state.copyWith(isGenerating: false, errorMessage: event.message));
  }

  @override
  Future<void> close() {
    _eventSub?.cancel();
    repository.dispose();
    return super.close();
  }
}
