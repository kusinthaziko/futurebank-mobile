import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class ChatInput extends StatefulWidget {
  final bool disabled;
  final ValueChanged<String> onSend;

  const ChatInput({super.key, required this.disabled, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _ctrl = TextEditingController();
  final _stt = SpeechToText();
  bool _isListening = false;

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _ctrl.clear();
  }

  Future<void> _toggleVoice() async {
    if (_isListening) {
      await _stt.stop();
      setState(() => _isListening = false);
    } else {
      final available = await _stt.initialize();
      if (available) {
        setState(() => _isListening = true);
        _stt.listen(
          onResult: (r) => setState(() => _ctrl.text = r.recognizedWords),
        );
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _stt.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: gray300)),
        color: cardColor,
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? error500 : gray500,
            ),
            onPressed: widget.disabled ? null : _toggleVoice,
          ),
          const SizedBox(width: sp8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              enabled: !widget.disabled,
              textInputAction: TextInputAction.send,
              onSubmitted: widget.disabled ? null : (_) => _send(),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: gray500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: sp8),
          widget.disabled
              ? const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(
                  icon: const Icon(Icons.send, color: primary500),
                  onPressed: _send,
                ),
        ]),
      ),
    );
  }
}
