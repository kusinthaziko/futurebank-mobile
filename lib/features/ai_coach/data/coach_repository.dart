import 'package:genui/genui.dart' hide TextPart;
import 'package:genui/genui.dart' as genui;
import 'package:graphql_flutter/graphql_flutter.dart';
import '../domain/coach_bloc.dart';
import '../catalog/coach_catalog.dart';

const _askCoachMutation = r'''
  mutation AskCoach($message: String!, $sessionId: String) {
    askCoach(message: $message, session_id: $sessionId) {
      content session_id
    }
  }
''';

class CoachRepositoryImpl implements CoachRepository {
  final GraphQLClient graphqlClient;

  late SurfaceController _controller;
  late A2uiTransportAdapter _transport;
  late Conversation _conversation;
  String? _sessionId;
  bool isReady = false;

  CoachRepositoryImpl({required this.graphqlClient});

  @override
  SurfaceController get controller => _controller;

  @override
  Stream<ConversationEvent> get events => _conversation.events;

  @override
  Future<void> startConversation() async {
    final catalog = buildCoachCatalog();
    _controller = SurfaceController(catalogs: [catalog]);

    _transport = A2uiTransportAdapter(
      onSend: (ChatMessage message) async {
        // Extract text from message parts — same as studyapp pattern
        final buffer = StringBuffer();
        for (final part in message.parts) {
          if (part.isUiInteractionPart) {
            buffer.write(part.asUiInteractionPart!.interaction);
          } else if (part is genui.TextPart) {
            buffer.write(part.text);
          }
        }
        final text = buffer.toString();
        if (text.trim().isEmpty) return;

        // Call Phoenix backend GraphQL
        final result = await graphqlClient.mutate(MutationOptions(
          document: gql(_askCoachMutation),
          variables: {'message': text, 'sessionId': _sessionId},
        ));

        if (!result.hasException) {
          final data = result.data?['askCoach'];
          _sessionId = data?['session_id'];
          final content = data?['content'] as String? ?? '';
          // Pipe response to genui transport so it can parse A2UI widgets
          _transport.addChunk(content);
        }
      },
    );

    _conversation = Conversation(
      controller: _controller,
      transport: _transport,
    );
    isReady = true;
  }

  @override
  Future<void> sendMessage(String text) async {
    await _conversation.sendRequest(ChatMessage.user(text));
  }

  @override
  void dispose() {
    _conversation.dispose();
    _controller.dispose();
    _transport.dispose();
  }
}
