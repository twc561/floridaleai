
import 'package:flutter/foundation.dart';

enum ChatSender { officer, subject, system }

@immutable
class ChatMessage {
  final String text;
  final ChatSender sender;
  final String? feedback; // Immediate, out-of-character training feedback
  final String? reportCardNote; // Note for the final summary
  final String? dynamicEvent; // An unexpected event injected by the AI

  const ChatMessage({
    required this.text,
    required this.sender,
    this.feedback,
    this.reportCardNote,
    this.dynamicEvent,
  });

  // Factory constructor to parse the JSON from Gemini
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['response'] as String? ?? '(No verbal response)', // Use 'response' key for text
      sender: ChatSender.subject, // Responses are always from the 'subject'
      feedback: json['feedback'] as String?,
      reportCardNote: json['report_card_note'] as String?,
      dynamicEvent: json['dynamic_event'] as String?,
    );
  }
}
