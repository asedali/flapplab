import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/chat_message.dart';

/// Notifier for managing chat messages
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  /// Add a message to the chat
  void addMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [...state.messages, message],
    );
  }

  /// Remove typing indicator from messages
  void removeTypingIndicator() {
    state = state.copyWith(
      messages: state.messages.where((m) => !m.isTypingIndicator).toList(),
    );
  }

  /// Clear all messages
  void clear() {
    state = const ChatState();
  }
}

/// State provider for chat
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

/// Immutable state for chat feature
class ChatState {
  final List<ChatMessage> messages;

  const ChatState({
    this.messages = const [],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }
}
