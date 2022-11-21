import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TextMessageEntity extends Equatable {
  final String? senderUID;
  final String? senderUsername;
  final String? recipientName;
  final String? recipientUID;
  final String? messageType;
  final String? message;
  final String? messageId;
  final Timestamp? time;

  const TextMessageEntity({
    this.senderUID,
    this.senderUsername,
    this.recipientName,
    this.recipientUID,
    this.messageType,
    this.message,
    this.messageId,
    this.time,
  });

  @override
  List<Object?> get props => [
        senderUID,
        senderUsername,
        recipientName,
        recipientUID,
        messageType,
        message,
        messageId,
        time,
      ];
}
