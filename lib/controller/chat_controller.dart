import '../model/chat_message.dart';

class ChatController {
 List<ChatMessage> messages = [
  ChatMessage(text: 'Hi, are you in the way?', isMe: true),
  ChatMessage(text: 'Yes, I am 5 minutes away.', isMe: false),
];

  void sendMessage(String text, bool isMe) {
    if (text.trim().isEmpty) return;

    messages.add(
      ChatMessage(text: text, isMe: isMe),
    );
  }
}