enum ChatSender { officer, subject, system }

class ChatMessage {
  final String text;
  final ChatSender sender;
  final String? feedback; // Immediate, out-of-character training feedback
  final String? reportCardNote; // Note for the final summary
  final String? dynamicEvent; // An unexpected event injected by the AI

  ChatMessage({
    required this.text,
    required this.sender,
    this.feedback,
    this.reportCardNote,
    this.dynamicEvent,
  });
}
