import 'dart:js_interop';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:latihanpost/services/api_services.dart';

part "profile_event.dart";
part "profile_state.dart";

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ApiServices _apiServices;

  UserProfileBloc(this._apiServices) : super(LoadingUserProfileState()) {
    on<FetchUserProfileEvent>(_fetchUserProfile);
  }

  Future<void> _fetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(LoadingUserProfileState());

    try {
      final response = await _apiServices.profile();
      final jsonData = json.decode(response.body);
      
      emit(LoadedUserProfileState(jsonData));
    } catch (e) {
      print(e.toString());
      emit(ErrorUserProfileState('Failed to fetch user profile.'));
    }
  }
}
