import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone_app/domain/entities/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  const TextMessageModel({
    String? senderUsername,
    String? senderUID,
    String? recipientName,
    String? recipientUID,
    String? messageType,
    String? message,
    String? messageId,
    Timestamp? time,
  }) : super(
          senderUsername: senderUsername,
          senderUID: senderUID,
          recipientName: recipientName,
          recipientUID: recipientUID,
          messageType: messageType,
          message: message,
          messageId: messageId,
          time: time,
        );

  factory TextMessageModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TextMessageModel(
      senderUsername: snapshot['senderUsername'],
      senderUID: snapshot['senderUID'],
      recipientName: snapshot['recipientName'],
      recipientUID: snapshot['recipientUID'],
      messageType: snapshot['messageType'],
      message: snapshot['message'],
      messageId: snapshot['messageId'],
      time: snapshot['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        "senderUsername": senderUsername,
        "senderUID": senderUID,
        "recipientName": recipientName,
        "recipientUID": recipientUID,
        "messageType": messageType,
        "message": message,
        "messageId": messageId,
        "time": time,
      };
}
