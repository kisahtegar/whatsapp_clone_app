import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone_app/domain/entities/user_entity.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:whatsapp_clone_app/domain/use_cases/sign_in_with_phone_numbera_usecase.dart';
import 'package:whatsapp_clone_app/domain/use_cases/verify_phone_number_usecase.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;

  PhoneAuthCubit({
    required this.signInWithPhoneNumberUseCase,
    required this.verifyPhoneNumberUseCase,
    required this.getCreateCurrentUserUseCase,
  }) : super(PhoneAuthInitial());

  Future<void> submitVerifyPhoneNumber({required String phoneNumber}) async {
    emit(PhoneAuthLoading());
    try {
      debugPrint("PhoneAuthCubit: VerifyPhoneNumber");
      await verifyPhoneNumberUseCase.call(phoneNumber);
      emit(PhoneAuthSmsCodeReceived());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (_) {
      emit(PhoneAuthFailure());
    }
  }

  Future<void> submitSmsCode({required String smsCode}) async {
    emit(PhoneAuthLoading());
    try {
      debugPrint("PhoneAuthCubit: signInWithPhoneNumber -> submitSmsCode");
      await signInWithPhoneNumberUseCase.call(smsCode);
      emit(PhoneAuthProfileInfo());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (_) {
      emit(PhoneAuthFailure());
    }
  }

  Future<void> submitProfileInfo({
    required String name,
    required String profileUrl,
    required String phoneNumber,
  }) async {
    try {
      debugPrint("PhoneAuthCubit: GetCreateCurrentUser");
      await getCreateCurrentUserUseCase.call(UserEntity(
        uid: "",
        name: name,
        email: "",
        profileUrl: profileUrl,
        phoneNumber: phoneNumber,
        isOnline: true,
        status: "",
      ));
      emit(PhoneAuthSuccess());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (e) {
      emit(PhoneAuthFailure());
    }
  }

  void unRegisterPhone() => emit(PhoneAuthLogout());
}
