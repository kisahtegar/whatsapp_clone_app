import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone_app/app_const.dart';
import 'package:whatsapp_clone_app/domain/entities/my_chat_entity.dart';
import 'package:whatsapp_clone_app/domain/entities/text_message_entity.dart';
import 'package:whatsapp_clone_app/domain/use_cases/add_to_my_chat_usecase.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_text_messages_usecase.dart';
import 'package:whatsapp_clone_app/domain/use_cases/send_text_message_usecase.dart';
import 'package:whatsapp_clone_app/presentation/pages/chat_page.dart';

part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final GetTextMessagesUseCase getTextMessagesUseCase;
  final GetOneToOneSingleUserChatChannelUseCase
      getOneToOneSingleUserChatChannelUseCase;
  final AddToMyChatUseCase addToMyChatUseCase;

  CommunicationCubit({
    required this.sendTextMessageUseCase,
    required this.addToMyChatUseCase,
    required this.getOneToOneSingleUserChatChannelUseCase,
    required this.getTextMessagesUseCase,
  }) : super(CommunicationInitial());

  Future<void> sendTextMessage({
    String? senderName,
    String? senderId,
    String? recipientId,
    String? recipientName,
    String? message,
    String? recipientPhoneNumber,
    String? senderPhoneNumber,
  }) async {
    try {
      final channelId = await getOneToOneSingleUserChatChannelUseCase.call(
        senderId!,
        recipientId!,
      );

      await sendTextMessageUseCase.sendTextMessage(
        TextMessageEntity(
          senderUsername: senderName,
          recipientName: recipientName,
          senderUID: senderId,
          recipientUID: recipientId,
          time: Timestamp.now(),
          message: message,
          messageId: "",
          messageType: AppConst.text,
        ),
        channelId,
      );

      await addToMyChatUseCase.call(MyChatEntity(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: message,
        profileURL: "",
        isRead: true,
        isArchived: false,
        channelId: channelId,
      ));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<void> getMessages({String? senderId, String? recipientId}) async {
    emit(CommunicationLoading());
    try {
      final channelId = await getOneToOneSingleUserChatChannelUseCase.call(
        senderId!,
        recipientId!,
      );

      final messageStreamData = getTextMessagesUseCase.call(channelId);

      messageStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }
}
