import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone_app/data/models/user_model.dart';
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
}
