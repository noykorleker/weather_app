class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
  });

  /// Factory method to create a `UserModel` from a map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  /// Converts the `UserModel` to a map.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
    };
  }

  /// Copies the `UserModel` while allowing specific fields to be updated.
  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }

  /// Updates a single field in the `UserModel` based on the provided key and value.
  UserModel copyWithField(String key, dynamic value) {
    switch (key) {
      case 'firstName':
        return copyWith(firstName: value as String);
      case 'lastName':
        return copyWith(lastName: value as String);
      case 'email':
        return copyWith(email: value as String);
      case 'gender':
        return copyWith(gender: value as String);
      default:
        throw ArgumentError('Invalid field: $key');
    }
  }

  /// Returns a default `UserModel` instance for guests or initial use.
  factory UserModel.defaultUser() => UserModel(
        uid: '',
        firstName: 'Default',
        lastName: 'User',
        email: 'default@example.com',
        gender: 'Other',
      );
}
