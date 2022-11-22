import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone_app/domain/entities/my_chat_entity.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_my_chat_usecase.dart';

part 'my_chat_state.dart';

class MyChatCubit extends Cubit<MyChatState> {
  final GetMyChatUseCase getMyChatUseCase;

  MyChatCubit({required this.getMyChatUseCase}) : super(MyChatInitial());

  Future<void> getMyChat({String? uid}) async {
    try {
      final myChatStreamData = getMyChatUseCase.call(uid!);
      myChatStreamData.listen((myChatData) {
        emit(MyChatLoaded(myChat: myChatData));
      });
    } on SocketException catch (_) {
    } catch (_) {}
  }
}
