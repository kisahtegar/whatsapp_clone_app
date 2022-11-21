import '../../../domain/entities/my_chat_entity.dart';
import '../../../domain/entities/text_message_entity.dart';
import '../../../domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  // Credential Features
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> signInWithPhoneNumber(String smsPinCode);
  Future<bool> isSignIn();
  Future<void> signOut();
  // User Features
  Future<String> getCurrentUID();
  Future<void> getCreateCurrentUser(UserEntity user);

  Stream<List<UserEntity>> getAllUsers();
  Stream<List<TextMessageEntity>> getTextMessages(String channelId);
  Stream<List<MyChatEntity>> getMyChat(String uid);

  Future<void> createOneToOneChatChannel(String uid, String otherUid);
  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid);
  Future<void> addToMyChat(MyChatEntity myChatEntity);
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId);
}
