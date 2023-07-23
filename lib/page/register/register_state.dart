part of 'register_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String message;

  RegistrationSuccess(this.message);
}

class RegistrationValidationFailed extends RegistrationState {
  final Map<String, dynamic> message;

  RegistrationValidationFailed(this.message);
}

class RegistrationError extends RegistrationState {
  final String message;

  RegistrationError(this.message);
}
