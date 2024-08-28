class UserData {
  late String userName;
  late String id;
  late String emailAddress;
  late String phoneNumber;
  late String bio;
  late String profileImage;
  late String coverImage;

  UserData({
    required this.userName,
    required this.id,
    required this.emailAddress,
    required this.phoneNumber,
    required this.bio,
    required this.profileImage,
    required this.coverImage,
  });

  UserData.fromJson(Map<String, dynamic>? json) {
    userName = json?['userName'];
    id = json?['id'];
    emailAddress = json?['emailAddress'];
    phoneNumber = json?['phoneNumber'];
    bio = json?['bio'];
    profileImage = json?['profileImage'];
    coverImage = json?['coverImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'id': id,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'profileImage': profileImage,
      'coverImage': coverImage,
    };
  }
}
