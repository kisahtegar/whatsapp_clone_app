import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone_app/data/data_sources/remote_data_sources/firebase_remote_data_source.dart';
import 'package:whatsapp_clone_app/data/data_sources/remote_data_sources/firebase_remote_data_source_impl.dart';
import 'package:whatsapp_clone_app/data/repositories/firebase_repository_impl.dart';
import 'package:whatsapp_clone_app/domain/repositories/firebase_repository.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:whatsapp_clone_app/presentation/bloc/auth/auth_cubit.dart';
import 'package:whatsapp_clone_app/presentation/bloc/phone_auth/phone_auth_cubit.dart';

import 'domain/use_cases/get_current_uid_usecase.dart';
import 'domain/use_cases/is_sign_in_usecase.dart';
import 'domain/use_cases/sign_in_with_phone_numbera_usecase.dart';
import 'domain/use_cases/sign_out_usecase.dart';
import 'domain/use_cases/verify_phone_number_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      getCurrentUidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );

  sl.registerFactory<PhoneAuthCubit>(
    () => PhoneAuthCubit(
      signInWithPhoneNumberUseCase: sl.call(),
      verifyPhoneNumberUseCase: sl.call(),
      getCreateCurrentUserUseCase: sl.call(),
    ),
  );

  // Usecase
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUseCase>(
      () => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInWithPhoneNumberUseCase>(
      () => SignInWithPhoneNumberUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
      () => VerifyPhoneNumberUseCase(repository: sl.call()));

  // Repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(
      remoteDataSource: sl.call(),
    ),
  );

  // Remote data
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      auth: sl.call(),
      fireStore: sl.call(),
    ),
  );

  // External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}
