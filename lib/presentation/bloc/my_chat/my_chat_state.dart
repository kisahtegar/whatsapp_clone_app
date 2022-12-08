part of 'my_chat_cubit.dart';

abstract class MyChatState extends Equatable {
  const MyChatState();

  @override
  List<Object> get props => [];
}

class MyChatInitial extends MyChatState {}

class MyChatLoading extends MyChatState {}

class MyChatFailure extends MyChatState {}

class MyChatLoaded extends MyChatState {
  final List<MyChatEntity> myChat;

  const MyChatLoaded({required this.myChat});
  @override
  List<Object> get props => [myChat];
}
