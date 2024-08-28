class PostModel {
  late String userName;
  late String userId;
  late String profileImage;
  late String postTime;
  String? postText;
  String? postImage;

  PostModel({
    required this.userName,
    required this.userId,
    required this.profileImage,
    required this.postTime,
    required this.postText,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    userName = json?['userName'];
    userId = json?['userId'];
    profileImage = json?['profileImage'];
    postTime = json?['postTime'];
    postText = json?['postText'];
    postImage = json?['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userId': userId,
      'profileImage': profileImage,
      'postTime': postTime,
      'postText': postText,
      'postImage': postImage,
    };
  }
}
