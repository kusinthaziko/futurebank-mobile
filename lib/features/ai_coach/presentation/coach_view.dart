import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import '../domain/coach_bloc.dart';
import '../domain/coach_event.dart';
import '../domain/coach_state.dart';
import '../../../core/design_system/tokens/colors.dart';
import '../../../core/design_system/tokens/dimensions.dart';
import '../../../core/design_system/tokens/typography.dart';
import 'widgets/chat_input.dart';
import 'widgets/weekly_insights.dart';

class CoachView extends StatelessWidget {
  final SurfaceController surfaceHost;

  const CoachView({super.key, required this.surfaceHost});

  static const _defaultSuggestions = [
    'How am I doing financially?',
    'Can I afford a loan?',
    'Where does my money go?',
    'Show my savings goals',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachBloc, CoachState>(
      builder: (ctx, state) => Column(
        children: [
          if (state.weeklyInsight != null)
            const WeeklyInsightsCard(
              amountSaved: 'MWK 3,200',
              savingsChange: '\u2191 18%',
              topSpendCategory: 'Data bundles',
              topSpendAmount: 'MWK 800',
              loanStatus: 'On track',
              healthScoreChange: '720 (\u2191 15 pts)',
            ),
          Expanded(
            child: state.allMessages.isEmpty
                ? _buildWelcome(ctx)
                : ListView.builder(
                    padding: const EdgeInsets.all(sp16),
                    itemCount:
                        state.allMessages.length + (state.isGenerating ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == state.allMessages.length) {
                        return const _TypingIndicator();
                      }
                      return switch (state.allMessages[i]) {
                        UserMessage(:final text) => _UserBubble(text: text),
                        AiSurfaceMessage(:final surfaceId) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: sp8),
                          child: Surface(
                            surfaceContext: surfaceHost.contextFor(surfaceId),
                          ),
                        ),
                        AiFallbackMessage(:final text) => _AiBubble(text: text),
                      };
                    },
                  ),
          ),
          ChatInput(
            disabled: state.isGenerating,
            onSend: (text) => ctx.read<CoachBloc>().add(CoachMessageSent(text)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    final suggestions = _getSuggestions(context);
    return Padding(
      padding: const EdgeInsets.all(sp24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primary100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.psychology, size: 40, color: primary500),
          ),
          const SizedBox(height: sp16),
          const Text(
            "Hi! I'm your financial coach.",
            style: AppTextStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: sp8),
          Text(
            'Ask me anything about your money.',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500),
          ),
          const SizedBox(height: sp24),
          Wrap(
            spacing: sp8,
            runSpacing: sp8,
            children: suggestions
                .map(
                  (s) => ActionChip(
                    label: Text(s, style: AppTextStyles.labelMedium),
                    onPressed: () =>
                        context.read<CoachBloc>().add(CoachMessageSent(s)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  List<String> _getSuggestions(BuildContext context) {
    return _defaultSuggestions;
  }
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
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: const BoxDecoration(
        color: primary500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: white)),
    ),
  );
}

class _AiBubble extends StatefulWidget {
  final String text;
  const _AiBubble({required this.text});

  @override
  State<_AiBubble> createState() => _AiBubbleState();
}

class _AiBubbleState extends State<_AiBubble> {
  int _revealedChars = 0;
  bool _cursorVisible = true;

  Timer? _typewriterTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  @override
  void didUpdateWidget(_AiBubble old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _typewriterTimer?.cancel();
      _revealedChars = 0;
      _startTypewriter();
    }
  }

  void _startTypewriter() {
    if (widget.text.isEmpty) return;

    // Start cursor blinking immediately
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 530),
      (_) {
        if (!mounted) return;
        setState(() => _cursorVisible = !_cursorVisible);
      },
    );

    // Reveal characters at ~40 chars/sec (25ms per char)
    // Batch 1-2 chars per tick for natural feel
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
            _revealedChars = (_revealedChars + 1).clamp(0, widget.text.length);
      setState(() {
        _revealedChars = (_revealedChars + advance).clamp(0, widget.text.length);
        if (_revealedChars >= widget.text.length) {
          timer.cancel();
          _cursorTimer?.cancel();
          _cursorVisible = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayed = widget.text.substring(0, _revealedChars);
    final isTyping = _revealedChars < widget.text.length;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: sp4),
        padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                displayed,
                style: AppTextStyles.bodyMedium.copyWith(color: gray900),
              ),
            ),
            if (isTyping && _cursorVisible)
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Container(
                  width: 2,
                  height: 16,
                  color: primary500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: sp4),
      padding: const EdgeInsets.all(sp12),
      decoration: BoxDecoration(
        color: gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: primary500),
          ),
          const SizedBox(width: sp8),
          Text(
            'Thinking...',
            style: AppTextStyles.caption.copyWith(color: gray500),
          ),
        ],
      ),
    ),
  );
}
