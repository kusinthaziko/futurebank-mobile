import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../domain/coach_bloc.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class CoachView extends StatefulWidget {
  final SurfaceController surfaceController;
  const CoachView({super.key, required this.surfaceController});

  @override
  State<CoachView> createState() => _CoachViewState();
}

class _CoachViewState extends State<CoachView> {
  final _ctrl = TextEditingController();
  final _stt = SpeechToText();
  bool _isListening = false;

  static const _suggestions = [
    'How am I doing financially?',
    'Can I afford a loan?',
    'Where does my money go?',
    'Show my savings goals',
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    context.read<CoachBloc>().add(CoachMessageSent(text.trim()));
    _ctrl.clear();
  }

  Future<void> _toggleVoice() async {
    if (_isListening) {
      await _stt.stop();
      setState(() => _isListening = false);
    } else {
      if (await _stt.initialize()) {
        setState(() => _isListening = true);
        _stt.listen(onResult: (r) => setState(() => _ctrl.text = r.recognizedWords));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachBloc, CoachState>(
      builder: (ctx, state) => Column(children: [
        Expanded(
          child: state.messages.isEmpty
              ? _buildWelcome()
              : ListView.builder(
                  padding: const EdgeInsets.all(sp16),
                  itemCount: state.messages.length + (state.isGenerating ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == state.messages.length) return _TypingIndicator();
                    return switch (state.messages[i]) {
                      UserMessage(:final text) => _UserBubble(text: text),
                      AiSurfaceMessage(:final surfaceId) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: sp8),
                          child: Surface(
                            surfaceContext: widget.surfaceController.contextFor(surfaceId),
                          )),
                      AiFallbackMessage(:final text) => _AiBubble(text: text),
                    };
                  },
                ),
        ),
        _buildInput(state),
      ]),
    );
  }

  Widget _buildWelcome() => Padding(
    padding: const EdgeInsets.all(sp24),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80,
          decoration: BoxDecoration(color: primary100, borderRadius: BorderRadius.circular(40)),
          child: const Icon(Icons.psychology, size: 40, color: primary500)),
      const SizedBox(height: sp16),
      Text("Hi! I'm your financial coach.",
          style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
      const SizedBox(height: sp24),
      Wrap(spacing: sp8, runSpacing: sp8,
          children: _suggestions.map((s) =>
              ActionChip(label: Text(s), onPressed: () => _send(s))).toList()),
    ]),
  );

  Widget _buildInput(CoachState state) => Container(
    padding: const EdgeInsets.all(sp12),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: gray300))),
    child: Row(children: [
      IconButton(
        icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? error500 : gray500),
        onPressed: _toggleVoice,
      ),
      Expanded(child: TextField(
        controller: _ctrl,
        decoration: const InputDecoration(hintText: 'Ask anything...', border: InputBorder.none),
        onSubmitted: _send,
      )),
      state.isGenerating
          ? const Padding(padding: EdgeInsets.all(sp8),
              child: SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)))
          : IconButton(
              icon: const Icon(Icons.send, color: primary500),
              onPressed: () => _send(_ctrl.text)),
    ]),
  );
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: sp4),
      padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: const BoxDecoration(color: primary500,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(4))),
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: white)),
    ),
  );
}

class _AiBubble extends StatelessWidget {
  final String text;
  const _AiBubble({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: sp4),
      padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(color: gray100, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: gray900)),
    ),
  );
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: sp4),
      padding: const EdgeInsets.all(sp12),
      decoration: BoxDecoration(color: gray100, borderRadius: BorderRadius.circular(12)),
      child: Text('Thinking...', style: AppTextStyles.caption.copyWith(color: gray500)),
    ),
  );
}
