class ChatMessage {
  final String text;   // نص الرسالة
  final bool isMe;     // true = أنا، false = السائق

  ChatMessage({
    required this.text,
    required this.isMe,
  });
}