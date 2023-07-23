import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihanpost/services/api_services.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Cubit<RegistrationState> {
  final ApiServices _apiServices;

  RegistrationBloc(this._apiServices) : super(RegistrationInitial());

  void registerTrigger(String name, String email, String password) async {
    emit(RegistrationLoading());

    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        emit(RegistrationError('Silakan isi semua formnya masbro'));
      } else {
        final response = await _apiServices.registerUser(name, email, password);

        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          emit(RegistrationSuccess(responseData['message']));
        } else if (response.statusCode == 400) {
          final responseData = json.decode(response.body);
          emit(RegistrationValidationFailed(responseData['errors']));
        } else {
          final responseData = json.decode(response.body);
          print(responseData);
          emit(RegistrationError('Registrasi Gagal'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(RegistrationError('Error cok'));
    }
  }
}
