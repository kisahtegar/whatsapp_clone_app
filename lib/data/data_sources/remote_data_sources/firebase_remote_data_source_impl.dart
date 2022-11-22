import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone_app/data/models/my_chat_model.dart';
import 'package:whatsapp_clone_app/data/models/text_message_model.dart';
import 'package:whatsapp_clone_app/data/models/user_model.dart';
import 'package:whatsapp_clone_app/domain/entities/text_message_entity.dart';
import 'package:whatsapp_clone_app/domain/entities/my_chat_entity.dart';
import 'package:whatsapp_clone_app/domain/entities/user_entity.dart';

import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl extends FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  String _verificationId = "";

  FirebaseRemoteDataSourceImpl({required this.auth, required this.fireStore});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUID();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        status: user.status,
        phoneNumber: user.phoneNumber,
        profileUrl: user.profileUrl,
        isOnline: user.isOnline,
        email: user.email,
      ).toJson();

      if (!userDoc.exists) {
        // create new user doc
        userCollection.doc(uid).set(newUser);
      } else {
        // Update user doc
        userCollection.doc(uid).update(newUser);
      }
    });
  }

  @override
  Future<String> getCurrentUID() async => auth.currentUser!.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsPinCode,
    );

    await auth.signInWithCredential(authCredential);
  }

  @override
  Future<void> signOut() async => await auth.signOut();

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // Phone Verification Completed
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) {
      print("phone verified : Token ${authCredential.token}");
    };

    // Phone Verification Failed
    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      print(
        "phone failed : ${firebaseAuthException.message},${firebaseAuthException.code}",
      );
    };

    // Phone Verification Timeout
    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
      print("time out :$verificationId");
    };

    // Phone Code Sent
    final PhoneCodeSent phoneCodeSent =
        (String verificationId, [int? forceResendingToken]) {
      this._verificationId = verificationId;
      print("sendPhoneCode $verificationId");
    };

    //FirebaseAuth verify phone number
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 10),
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async {
    final myChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myChat');

    final otherChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myChat');

    final myNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.senderName,
      senderUID: myChatEntity.senderUID,
      recipientUID: myChatEntity.recipientUID,
      recipientName: myChatEntity.recipientName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
    ).toJson();

    final otherNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.recipientName,
      senderUID: myChatEntity.recipientUID,
      recipientUID: myChatEntity.senderUID,
      recipientName: myChatEntity.senderName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
    ).toJson();

    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        // create
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).set(otherNewChat);
        return;
      } else {
        // update
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).update(otherNewChat);
        return;
      }
    });
  }

  @override
  Future<void> createOneToOneChatChannel(String uid, String otherUid) async {
    final userCollection = fireStore.collection("users");
    final oneToOneChatChannel = fireStore.collection("myChatChannel");

    userCollection
        .doc(uid)
        .collection("engagedChatChannel")
        .doc(otherUid)
        .get()
        .then((chatChannelDoc) {
      if (chatChannelDoc.exists) {
        return;
      }

      // if chatChannelDoc not exists
      final _chatChannelId = oneToOneChatChannel.doc().id;
      var channelMap = {
        "channelId": _chatChannelId,
        "channelType": "oneToOneChat",
      };
      oneToOneChatChannel.doc(_chatChannelId).set(channelMap);

      // Set currentUser
      userCollection
          .doc(uid)
          .collection("engagedChatChannel")
          .doc(otherUid)
          .set(channelMap);

      // Set otherUser
      userCollection
          .doc(otherUid)
          .collection("engagedChatChannel")
          .doc(otherUid)
          .set(channelMap);
      return;
    });
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
        fireStore.collection('users').doc(uid).collection('myChat');

    return myChatRef.orderBy('time', descending: true).snapshots().map(
          (querySnap) =>
              querySnap.docs.map((e) => MyChatModel.fromSnapshor(e)).toList(),
        );
  }

  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid) {
    final userCollection = fireStore.collection("users");

    return userCollection
        .doc(uid)
        .collection("engagedChatChannel")
        .doc(otherUid)
        .get()
        .then((engagedChatChannel) {
      if (engagedChatChannel.exists) {
        return engagedChatChannel.data()?['channelId'];
      }
      return Future.value("");
    });
  }

  @override
  Stream<List<TextMessageEntity>> getTextMessages(String channelId) {
    final message = fireStore
        .collection('myChatChannel')
        .doc(channelId)
        .collection('messages');

    return message.orderBy('time').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((e) => TextMessageModel.fromSnapshot(e))
              .toList(),
        );
  }

  @override
  Future<void> sendTextMessage(
    TextMessageEntity textMessageEntity,
    String channelId,
  ) async {
    final message = fireStore
        .collection('myChatChannel')
        .doc(channelId)
        .collection('messages');

    final messageId = message.doc().id;

    final newMessage = TextMessageModel(
      message: textMessageEntity.message,
      messageId: messageId,
      messageType: textMessageEntity.messageType,
      recipientName: textMessageEntity.recipientName,
      recipientUID: textMessageEntity.recipientUID,
      senderUID: textMessageEntity.senderUID,
      senderUsername: textMessageEntity.senderUsername,
      time: textMessageEntity.time,
    ).toJson();

    message.doc(messageId).set(newMessage);
  }
}
