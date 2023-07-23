import 'package:bloc/bloc.dart';
import 'dart:convert';
import '../../services/api_services.dart';
part 'login_event.dart';
part 'login_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiServices _apiServices;
  AuthenticationBloc(this._apiServices) : super(AuthenticationInitial());

  Future<void> loginTrigger(String email, String password) async {
    emit(AuthenticationLoading());
    try {
      if (email.isEmpty || password.isEmpty) {
        emit(AuthenticationFailure('Lu isi semua la gilak'));
      } else {
        final response = await _apiServices.login(email, password);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['access_token'];
          final expired = data['expires_in'];
          final currentTime = DateTime.now();
          final expirationTime = currentTime.add(Duration(seconds: expired));
          await _apiServices.saveToken(
            token,
            expirationTime,
          );
          emit(AuthenticationSuccess(token));
        } else if (response.statusCode == 401) {
          final res = jsonDecode(response.body);
          emit(AuthenticationFailure(res['error']));
        } else {
          final errorMessage = 'Autentikasi gagal';
          emit(AuthenticationFailure(errorMessage));
        }
      }
    } catch (e) {
      final errorMessage = 'Terjadi kesalahan saat melakukan login';
      emit(AuthenticationFailure(errorMessage));
    }
  }
}
