part of 'profile_bloc.dart';

abstract class UserProfileState {}

class LoadingUserProfileState extends UserProfileState {}

class LoadedUserProfileState extends UserProfileState {
  final dynamic userProfile;

  LoadedUserProfileState(this.userProfile);

  get errorMessage => null;
}

class ErrorUserProfileState extends UserProfileState {
  final String errorMessage;
  ErrorUserProfileState(this.errorMessage);
}
