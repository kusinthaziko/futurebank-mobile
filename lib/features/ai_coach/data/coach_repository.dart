import 'dart:async';
import 'package:genui/genui.dart' hide TextPart;
import 'package:genui/genui.dart' as genui;
import 'package:graphql_flutter/graphql_flutter.dart';
import '../domain/coach_conversation_event.dart';
import '../domain/coach_bloc.dart' as domain;

const _askCoachMutation = r'''
  mutation AskCoach($message: String!, $sessionId: String) {
    askCoach(message: $message, sessionId: $sessionId) {
      content sessionId
    }
  }
''';

class CoachRepository implements domain.CoachRepository {
  final GraphQLClient graphqlClient;
  final Catalog catalog;
  final SurfaceController surfaceController;

  late final A2uiTransportAdapter _transport;
  late final Conversation _conversation;
  final StreamController<CoachConversationEvent> _eventController =
      StreamController<CoachConversationEvent>.broadcast();
  String? _sessionId;
  bool _ready = false;

  CoachRepository({
    required this.graphqlClient,
    required this.catalog,
    required this.surfaceController,
  });

  @override
  Stream<CoachConversationEvent> get events => _eventController.stream;
  SurfaceController get controller => surfaceController;
  bool get isReady => _ready;

  @override
  Future<void> startConversation() async {
    _transport = A2uiTransportAdapter(
      onSend: (ChatMessage message) async {
        final buffer = StringBuffer();
        for (final part in message.parts) {
          if (part.isUiInteractionPart) {
            buffer.write(part.asUiInteractionPart!.interaction);
          } else if (part is genui.TextPart) {
            buffer.write(part.text);
          }
        }
        final text = buffer.toString().trim();
        if (text.isEmpty) return;

        _eventController.add(CoachWaiting(true));
        try {
          final result = await graphqlClient.mutate(
            MutationOptions(
              document: gql(_askCoachMutation),
              variables: {'message': text, 'sessionId': _sessionId},
            ),
          );

          if (result.hasException) {
            _eventController.add(
              CoachError(
                result.exception?.graphqlErrors.firstOrNull?.message ??
                    'Request failed',
              ),
            );
            return;
          }

          final data = result.data?['askCoach'];
          _sessionId = data?['session_id'] as String?;
          final content = data?['content'] as String? ?? '';

          if (content.isEmpty) {
            _eventController.add(CoachError('Empty response from coach'));
            return;
          }

          _transport.addChunk(content);
        } catch (e) {
          _eventController.add(
            CoachError(e is Exception ? e.toString() : 'Unknown error'),
          );
        }
      },
    );

    _conversation = Conversation(
      controller: surfaceController,
      transport: _transport,
    );

    _conversation.events.listen(_mapConversationEvent);

    _ready = true;
    _eventController.add(CoachWaiting(false));
  }

  void _mapConversationEvent(ConversationEvent event) {
    if (event is ConversationSurfaceAdded) {
      _eventController.add(CoachSurfaceAdded(event.surfaceId));
    } else if (event is ConversationError) {
      _eventController.add(CoachError(event.error.toString()));
    }
  }

  @override
  Future<void> sendMessage(String text) async {
    if (!_ready) return;
    await _conversation.sendRequest(ChatMessage.user(text));
  }

  @override
  void dispose() {
    _eventController.close();
    _conversation.dispose();
    _transport.dispose();
  }
}
