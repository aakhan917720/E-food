class UserProfileModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String userRole;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userRole,
  });

  factory UserProfileModel.empty() {
    return const UserProfileModel(
      name: '',
      email: '',
      phoneNumber: '',
      userRole: 'customer',
    );
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? userRole,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userRole: userRole ?? this.userRole,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userRole': userRole,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      userRole: map['userRole'] ?? 'customer',
    );
  }
}