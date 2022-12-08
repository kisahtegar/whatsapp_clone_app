part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthSuccess extends PhoneAuthState {}

class PhoneAuthFailure extends PhoneAuthState {}

class PhoneAuthLogout extends PhoneAuthState {}

class PhoneAuthSmsCodeReceived extends PhoneAuthState {
  @override
  String toString() {
    print("Auth sms received");
    return super.toString();
  }
}

class PhoneAuthProfileInfo extends PhoneAuthState {}
