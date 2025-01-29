import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user/UserModel.dart';
import '../models/user/userBloc/user_bloc.dart';
import '../services/FirebaseService.dart';
import 'LoginScreen.dart';
import 'MainScreen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final firebaseService = FirebaseService();
    return StreamBuilder<User?>(
      stream: firebaseService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          firebaseService.getUserData(snapshot.data!.uid).then((userData) {
            if (userData != null) {
              final userModel = UserModel.fromMap(userData);
              userBloc.add(SetUser(userModel));
            }
          });

          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
