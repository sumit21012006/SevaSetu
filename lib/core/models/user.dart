class User {
  final String uid;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String language;
  final Map<String, dynamic> profileData;

  User({
    required this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.language = 'en',
    this.profileData = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'language': language,
      'profileData': profileData,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      language: map['language'] ?? 'en',
      profileData: map['profileData'] ?? {},
    );
  }
}
