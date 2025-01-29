import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/FirebaseService.dart';
import '../UserModel.dart';

part 'user_event.dart';
part 'user_state.dart';

/// UserBloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseService _firebaseService;

  UserBloc(this._firebaseService) : super(UserInitial()) {
    on<SetUser>(_onSetUser);
    on<ClearUser>(_onClearUser);
    on<UpdateUserField>(_onUpdateUserField);
    on<ResetUser>(_onResetUser);
    on<RegistrationStarted>(_onRegistrationStarted);
  }

  void _onSetUser(SetUser event, Emitter<UserState> emit) {
    debugPrint('UserBloc: User set with ID: ${event.user.uid}');
    emit(UserLoaded(event.user));
  }

  void _onClearUser(ClearUser event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final user = (state as UserLoaded).user;
      debugPrint('UserBloc: Clearing user with ID: ${user.uid}');
    } else {
      debugPrint('UserBloc: No user to clear.');
    }
    emit(UserCleared());
  }

  void _onUpdateUserField(UpdateUserField event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWithField(event.key, event.value);
      debugPrint(
          'UserBloc: Updated user field ${event.key} with value: ${event.value}');
      emit(UserLoaded(updatedUser));
    } else {
      debugPrint('UserBloc: Cannot update field, user is not loaded.');
    }
  }

  void _onResetUser(ResetUser event, Emitter<UserState> emit) {
    debugPrint('UserBloc: Resetting user to default state.');
    final defaultUser = UserModel.defaultUser();
    emit(UserLoaded(defaultUser));
  }

  Future<void> _onRegistrationStarted(
      RegistrationStarted event, Emitter<UserState> emit) async {
    emit(RegistrationInProgress());

    try {
      final userModel = await _firebaseService.registerUser(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        gender: event.gender,
      );

      emit(UserLoaded(userModel));
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error, please check your connection.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }

      emit(RegistrationFailed(errorMessage));
    } catch (e) {
      debugPrint('Unexpected registration error: $e');
      emit(RegistrationFailed(
          'An unexpected error occurred. Please try again.'));
    }
  }
}

// Event
class RegistrationStarted extends UserEvent {
  final String firstName, lastName, email, password, gender;

  const RegistrationStarted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password, gender];
}

// State
class RegistrationInProgress extends UserState {}

class RegistrationFailed extends UserState {
  final String error;

  const RegistrationFailed(this.error);

  @override
  List<Object?> get props => [error];
}
