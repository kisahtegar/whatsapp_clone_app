import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone_app/domain/entities/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  const MyChatModel({
    String? senderName,
    String? senderUID,
    String? recipientName,
    String? recipientUID,
    String? channelId,
    String? profileURL,
    String? recipientPhoneNumber,
    String? senderPhoneNumber,
    String? recentTextMessage,
    bool? isRead,
    bool? isArchived,
    Timestamp? time,
  }) : super(
          senderName: senderName,
          senderUID: senderUID,
          recipientName: recipientName,
          recipientUID: recipientUID,
          channelId: channelId,
          profileURL: profileURL,
          recipientPhoneNumber: recipientPhoneNumber,
          senderPhoneNumber: senderPhoneNumber,
          recentTextMessage: recentTextMessage,
          isRead: isRead,
          isArchived: isArchived,
          time: time,
        );

  factory MyChatModel.fromSnapshor(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyChatModel(
      senderName: snapshot['senderName'],
      senderUID: snapshot['senderUID'],
      recipientName: snapshot['recipientName'],
      recipientUID: snapshot['recipientUID'],
      channelId: snapshot['channelId'],
      profileURL: snapshot['profileURL'],
      recipientPhoneNumber: snapshot['recipientPhoneNumber'],
      senderPhoneNumber: snapshot['senderPhoneNumber'],
      recentTextMessage: snapshot['recentTextMessage'],
      isRead: snapshot['isRead'],
      isArchived: snapshot['isArchived'],
      time: snapshot['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        "senderName": senderName,
        "senderUID": senderUID,
        "recipientName": recipientName,
        "recipientUID": recipientUID,
        "channelId": channelId,
        "profileURL": profileURL,
        "recipientPhoneNumber": recipientPhoneNumber,
        "senderPhoneNumber": senderPhoneNumber,
        "recentTextMessage": recentTextMessage,
        "isRead": isRead,
        "isArchived": isArchived,
        "time": time,
      };
}
