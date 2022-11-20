import 'package:whatsapp_clone_app/data/data_sources/remote_data_sources/firebase_remote_data_source.dart';
import 'package:whatsapp_clone_app/domain/entities/user_entity.dart';
import 'package:whatsapp_clone_app/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUID() async => remoteDataSource.getCurrentUID();

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async =>
      await remoteDataSource.signInWithPhoneNumber(smsPinCode);

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async =>
      await remoteDataSource.verifyPhoneNumber(phoneNumber);
}
