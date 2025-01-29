import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user/UserModel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  /// Stream auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Register a new user
  Future<UserModel> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Could not create user at this time.');
      }

      final userModel = UserModel(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
      );

      await _firestore.collection('users').doc(uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already in use.');
      } else if (e.code == 'invalid-email') {
        throw Exception('This email address is invalid.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  /// Login user with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Could not retrieve user information.');
      }

      final userData = await getUserData(uid);
      if (userData == null) {
        throw Exception('User data not found. Please contact support.');
      }

      return UserModel.fromMap(userData);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password provided.';
          break;
        case 'invalid-email':
          message = 'This email address is invalid.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  /// Fetch user details from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('This email address is invalid.');
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Delete the current user
  Future<void> deleteUser(String uid) async {
    try {
      // Delete user document in Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Delete user from FirebaseAuth
      User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        await currentUser.delete();
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        throw Exception(
            'This operation requires recent login. Please log in again and try.');
      } else {
        throw Exception('Error deleting user: $e');
      }
    }
  }

  bool _isHeartbeatWriting = false;

  Future<void> writeHeartbeatToDatabase(String uid, String timestamp) async {
    if (_isHeartbeatWriting) {
      return; // Prevent overlapping calls
    }
    _isHeartbeatWriting = true;

    try {
      final userDocRef = _firestore.collection('users').doc(uid);
      final heartbeatsCollection = userDocRef.collection('heartbeats');

      // Check for an existing document with the same timestamp
      final existingHeartbeat = await heartbeatsCollection
          .where('timestamp', isEqualTo: timestamp)
          .limit(1)
          .get();

      if (existingHeartbeat.docs.isEmpty) {
        // Add a new heartbeat if no duplicate is found
        await heartbeatsCollection.add({
          'timestamp': timestamp,
        });
        print("New heartbeat written for user $uid: $timestamp");
      } else {
        print("Duplicate heartbeat detected for user $uid: $timestamp");
      }
    } catch (e) {
      print("Error writing heartbeat for user $uid: $e");
    } finally {
      _isHeartbeatWriting = false;
    }
  }
}
