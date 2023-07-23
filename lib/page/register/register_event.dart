part of 'register_bloc.dart';

@immutable
abstract class RegistrationEvent {}

class RegisterButtonPressed extends RegistrationEvent {
  final String name;
  final String email;
  final String password;

  RegisterButtonPressed({
    required this.name,
    required this.email,
    required this.password,
  });
}