import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;       // نص الرسالة
  final String senderId;      // ID صاحب الرسالة
  final DateTime? timestamp;  // وقت الرسالة
  
  ChatMessage({
    required this.message,
    required this.senderId,
    this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      message: map['message'], 
      senderId: map['senderId'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "senderId": senderId,
      "timestamp": timestamp,
    };
  }
}
