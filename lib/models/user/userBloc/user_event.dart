part of 'user_bloc.dart';

/// User Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  List<Object?> get props => [];
}

class SetUser extends UserEvent {
  final UserModel user;

  const SetUser(this.user);

  @override
  List<Object?> get props => [user];
}

class ClearUser extends UserEvent {}

class UpdateUserField extends UserEvent {
  final String key;
  final dynamic value;

  const UpdateUserField(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class ResetUser extends UserEvent {}
