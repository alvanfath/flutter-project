import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import 'package:latihanpost/page/profile/update_profile/update_event.dart';
import 'package:latihanpost/page/profile/update_profile/update_state.dart';
import 'package:latihanpost/services/api_services.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final ApiServices _apiServices;
  UpdateProfileBloc(this._apiServices) : super(InitialProfileState()) {
    on<UpdateButtonPressed>(
      (event, emit) async {
        emit(UpdatingProfileState());
        try {
          final update =
              await _apiServices.updateProfile(event.name, event.email);
          if (update.statusCode == 200) {
            final responseData = json.decode(update.body);
            emit(UpdatedProfileState(message: responseData['message']));
          } else if (update.statusCode == 400) {
            final responseData = json.decode(update.body);
            emit(UpdateProfileStateError(errorMessage: responseData['errors']));
          } else {
            final responseData = json.decode(update.body);
            emit(
              UpdateProfileStateError(
                errorMessage:'sepertinya ada yang salah, silakan coba beberapa menit lagi',
              ),
            );
          }
        } catch (e) {
          emit(
            UpdateProfileStateError(
              errorMessage: e.toString(),
            ),
          );
        }
      },
    );
  }
}
