import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/material_result.dart';
import '../../result/result_card.dart';
import '../chat_provider.dart';

/// AI-Chat-First Home Screen
/// The primary interface - a conversational assistant with rich result cards
class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  ConsumerState<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends ConsumerState<ChatHomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(chatProvider);
      if (state.messages.isEmpty) {
        ref.read(chatProvider.notifier).addMessage(ChatMessage.welcome());
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header with greeting and status
            _buildHeader(),

            // Chat stream
            Expanded(
              child: _buildChatStream(state),
            ),

            // Quick action buttons (shown when chat is short)
            if (state.messages.length < 3) _buildQuickActions(notifier),

            // Input area
            _buildInputArea(notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.surfaceLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.accentPurple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          )
              .animate()
              .scale(delay: 0.ms, duration: 400.ms, curve: Curves.elasticOut),

          const SizedBox(width: 14),

          // Greeting and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good day',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text(
                      'NooraSense AI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.successColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Ready',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildChatStream(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[state.messages.length - 1 - index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isTypingIndicator) {
      return _buildTypingIndicator();
    }

    if (message.type == MessageType.result && message.result != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: MaterialResultCard(
          result: message.result!,
          isInChat: true,
        ),
      );
    }

    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentPurple],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryColor : AppTheme.surfaceDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideX(begin: isUser ? 0.1 : -0.1, end: 0),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.textSecondary.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          delay: Duration(milliseconds: index * 150),
          duration: const Duration(milliseconds: 300),
          begin: const Offset(0.8, 0.8),
        )
        .then()
        .scale(
          duration: const Duration(milliseconds: 300),
          begin: const Offset(1.2, 1.2),
          reverse: true,
        );
  }

  Widget _buildQuickActions(ChatNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _QuickActionButton(
            icon: Icons.document_scanner,
            label: 'Scan Material',
            onTap: () {
              AppHaptics.medium();
              context.push('/scan');
            },
          ),
          _QuickActionButton(
            icon: Icons.favorite_outline,
            label: 'Sync Health',
            onTap: () {
              AppHaptics.medium();
              context.push('/health-sync');
            },
          ),
          _QuickActionButton(
            icon: Icons.history,
            label: 'View History',
            onTap: () {
              AppHaptics.light();
              // TODO: Navigate to history
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildInputArea(ChatNotifier notifier) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.surfaceLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Microphone button
          IconButton(
            onPressed: () {
              AppHaptics.light();
              // TODO: Implement voice input
            },
            icon: const Icon(Icons.mic_none_outlined),
            color: AppTheme.textSecondary,
            splashRadius: 24,
          ),

          // Text input
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() => _isFocused = hasFocus);
              },
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask me anything...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppTheme.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    _sendMessage(notifier);
                  }
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Scan trigger button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentPurple],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                AppHaptics.medium();
                context.push('/scan');
              },
              icon: const Icon(Icons.qr_code_scanner),
              color: Colors.white,
              padding: const EdgeInsets.all(14),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(delay: 0.ms, duration: 1000.ms)
              .then()
              .scale(duration: 1000.ms, reverse: true),
        ],
      ),
    );
  }

  void _sendMessage(ChatNotifier notifier) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    AppHaptics.medium();
    notifier.addMessage(ChatMessage.user(text));
    _textController.clear();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        notifier.addMessage(ChatMessage.typing());
        
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            notifier.removeTypingIndicator();
            notifier.addMessage(ChatMessage.ai(
              "I understand you're asking about '$text'. In this demo, I can help you scan materials to get detailed analysis. Try tapping the scan button!",
            ));
          }
        });
      }
    });
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.surfaceLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
