import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/graphql/client.dart';

class _Message {
  final String role;
  final String content;
  const _Message({required this.role, required this.content});
}

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});
  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _stt = SpeechToText();
  final _messages = <_Message>[];
  bool _isTyping = false;
  bool _isListening = false;
  String? _sessionId;

  static const _suggestions = [
    'Can I afford a loan?',
    'How much can I save this month?',
    'Explain my health score',
  ];

  Future<void> _send(String message) async {
    if (message.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(role: 'user', content: message));
      _isTyping = true;
      _ctrl.clear();
    });
    _scrollToBottom();

    try {
      final token = ref.read(authProvider).accessToken;
      final client = ref.read(graphQLClientProvider(token));
      final result = await client.mutate(MutationOptions(
        document: gql(r'''
          mutation Ask($message: String!, $sessionId: String) {
            askCoach(message: $message, session_id: $sessionId) {
              content session_id
            }
          }
        '''),
        variables: {'message': message, 'sessionId': _sessionId},
      ));
      if (!result.hasException) {
        final data = result.data?['askCoach'];
        _sessionId = data?['session_id'];
        setState(() => _messages.add(
            _Message(role: 'assistant', content: data?['content'] ?? '')));
      }
    } catch (_) {
      setState(() => _messages.add(const _Message(
          role: 'assistant',
          content: "I'm having trouble right now. Try again in a moment.")));
    } finally {
      if (mounted) setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  Future<void> _toggleVoice() async {
    if (_isListening) {
      await _stt.stop();
      setState(() => _isListening = false);
    } else {
      final ok = await _stt.initialize();
      if (ok) {
        setState(() => _isListening = true);
        _stt.listen(onResult: (r) {
          setState(() => _ctrl.text = r.recognizedWords);
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
        actions: [
          if (_messages.isNotEmpty)
            TextButton(
              onPressed: () => setState(() { _messages.clear(); _sessionId = null; }),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: _messages.isEmpty
              ? _buildWelcome()
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(sp16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == _messages.length) return _TypingIndicator();
                    return _MessageBubble(message: _messages[i]);
                  },
                ),
        ),
        _buildInput(),
      ]),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.all(sp24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: primary100, borderRadius: BorderRadius.circular(40)),
          child: const Icon(Icons.psychology, size: 40, color: primary500),
        ),
        const SizedBox(height: sp16),
        Text("Hi! I'm your financial coach.",
            style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: sp8),
        Text('Ask me anything about your money.',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500),
            textAlign: TextAlign.center),
        const SizedBox(height: sp24),
        Wrap(spacing: sp8, runSpacing: sp8, children: _suggestions.map((s) =>
          ActionChip(label: Text(s), onPressed: () => _send(s))
        ).toList()),
      ]),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(sp12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: gray300))),
      child: Row(children: [
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? error500 : gray500),
          onPressed: _toggleVoice,
        ),
        Expanded(
          child: TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
              hintText: 'Type a message...',
              border: InputBorder.none),
            onSubmitted: _send,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, color: primary500),
          onPressed: () => _send(_ctrl.text),
        ),
      ]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: sp4),
        padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? primary500 : gray100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(message.content,
            style: AppTextStyles.bodyMedium.copyWith(
                color: isUser ? white : gray900)),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: sp4),
        padding: const EdgeInsets.all(sp12),
        decoration: BoxDecoration(color: gray100, borderRadius: radius12),
        child: Text('Thinking...', style: AppTextStyles.caption.copyWith(color: gray500)),
      ),
    );
  }
}
