part of 'communication_cubit.dart';

abstract class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object> get props => [];
}

class CommunicationInitial extends CommunicationState {}

class CommunicationLoading extends CommunicationState {}

class CommunicationFailure extends CommunicationState {}

class CommunicationLoaded extends CommunicationState {
  final List<TextMessageEntity> messages;

  const CommunicationLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}
