import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user/userBloc/user_bloc.dart';
import '../widgets/LoginPageWidgets/GradientBackground.dart';
import '../widgets/LoginPageWidgets/RegistrationForm.dart';
import 'MainScreen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Successful!')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              } else if (state is RegistrationFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error)), // Display the error message
                );
              }
            },
            builder: (context, state) {
              if (state is RegistrationInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05, vertical: 0),
                  child: RegistrationForm(
                    onSubmit: ({
                      required String firstName,
                      required String lastName,
                      required String email,
                      required String password,
                      required String gender,
                    }) {
                      context.read<UserBloc>().add(
                            RegistrationStarted(
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                              password: password,
                              gender: gender,
                            ),
                          );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
