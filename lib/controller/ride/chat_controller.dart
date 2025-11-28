import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/ride/chat_message.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // roomId is: driverID + "_" + studentID
  final String roomId;

  ChatController({required this.roomId});

  /// Send new chat message
  Future<void> sendMessage(String text, bool isMe) async {
    if (text.trim().isEmpty) return;

    await _firestore
        .collection("chat_rooms")
        .doc(roomId)
        .collection("messages")
        .add({
      "text": text,
      "isMe": isMe,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  /// Listen to messages in real-time
  Stream<List<ChatMessage>> getMessagesStream() {
    return _firestore
        .collection("chat_rooms")
        .doc(roomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();
    });
  }
}
