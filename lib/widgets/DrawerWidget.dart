import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../models/user/userBloc/user_bloc.dart';
import '../services/FirebaseService.dart';

class DrawerWidget extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String gender;

  const DrawerWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.gender,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _logout() async {
    await _firebaseService.signOut();
    context.read<UserBloc>().add(ClearUser());
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteUser() async {
    try {
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded) {
        final uid = userState.user.uid;
        await _firebaseService.deleteUser(uid);
        context.read<UserBloc>().add(ClearUser());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/register');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 70.sp,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Name: ${widget.userName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Email: ${widget.userEmail}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  "Gender: ${widget.gender}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: const Text(
              'Delete User',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: _deleteUser,
          ),
        ],
      ),
    );
  }
}
