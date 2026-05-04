import 'package:flutter/foundation.dart';
import 'material_result.dart';

/// Message types for the chat interface
enum MessageType {
  user,
  ai,
  system,
  result, // Special type for rich result cards
}

/// Represents a chat message in the AI conversation
@immutable
class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final MaterialResult? result; // For result-type messages
  final bool isTypingIndicator;

  const ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.result,
    this.isTypingIndicator = false,
  });

  ChatMessage copyWith({
    String? id,
    MessageType? type,
    String? content,
    DateTime? timestamp,
    MaterialResult? result,
    bool? isTypingIndicator,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      result: result ?? this.result,
      isTypingIndicator: isTypingIndicator ?? this.isTypingIndicator,
    );
  }

  /// Create a user message
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Create an AI response message
  factory ChatMessage.ai(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Create a system message
  factory ChatMessage.system(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.system,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Create a result message with material data
  factory ChatMessage.result(MaterialResult result) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.result,
      content: 'Scan Complete',
      timestamp: DateTime.now(),
      result: result,
    );
  }

  /// Create a typing indicator message
  factory ChatMessage.typing() {
    return ChatMessage(
      id: 'typing_${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.ai,
      content: '',
      timestamp: DateTime.now(),
      isTypingIndicator: true,
    );
  }

  /// Welcome message shown on app launch
  static ChatMessage welcome() {
    return ChatMessage.ai(
      "Hello! I'm your NooraSense AI assistant. I can help you analyze food materials, track nutrition, and sync with your health apps.\n\nWhat would you like to do today?",
    );
  }
}
