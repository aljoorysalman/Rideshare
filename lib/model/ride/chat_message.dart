import'package:cloud_firestore/cloud_firestore.dart';
class ChatMessage {
  final String text;   // نص الرسالة
  final bool isMe;     // true = أنا، false = السائق
   final DateTime? timestamp;

  
  ChatMessage({
    required this.text,
    required this.isMe,
    this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      isMe: map['isMe'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "isMe": isMe,
      "timestamp": timestamp,
    };
  }
}