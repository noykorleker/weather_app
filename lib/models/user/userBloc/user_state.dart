part of 'user_bloc.dart';

/// User States
abstract class UserState extends Equatable {
  const UserState();

  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserCleared extends UserState {}

class RegistrationError extends UserState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}
