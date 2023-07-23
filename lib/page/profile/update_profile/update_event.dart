import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/editable_text.dart';

abstract class UpdateProfileEvent extends Equatable {

  @override
  List<Object> get props => [];

  String get name;
  String get email;
}

class UpdateButtonPressed extends UpdateProfileEvent {
  final String name;
  final String email;

  UpdateButtonPressed({required this.name, required this.email});
}
