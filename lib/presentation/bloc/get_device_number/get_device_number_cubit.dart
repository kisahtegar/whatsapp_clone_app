import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:whatsapp_clone_app/domain/entities/contact_entity.dart';
import 'package:whatsapp_clone_app/domain/use_cases/get_device_number_usecase.dart';

part 'get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {
  GetDeviceNumberUseCase getDeviceNumberUseCase;
  GetDeviceNumberCubit({
    required this.getDeviceNumberUseCase,
  }) : super(GetDeviceNumberInitial());

  Future<void> getDeviceNumbers() async {
    // emit(GetDeviceNumberLoading());
    try {
      final contactNumbers = await getDeviceNumberUseCase.call();
      emit(GetDeviceNumberLoaded(contacts: contactNumbers));
    } catch (e) {
      emit(GetDeviceNumberFailure());
    }
  }
}
