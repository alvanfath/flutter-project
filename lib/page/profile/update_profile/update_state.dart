import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UpdateProfileState extends Equatable {}

class InitialProfileState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

class UpdatingProfileState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

class UpdatedProfileState extends UpdateProfileState {
  final String? message;

  UpdatedProfileState({this.message});
  
  @override
  List<Object?> get props => [];
}

class UpdateProfileStateError extends UpdateProfileState {
  final dynamic errorMessage;

  UpdateProfileStateError({required this.errorMessage});
  
  @override
  List<Object?> get props => [];
}
