import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/login/ui/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/news_feed/news_feed_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  late UserData userData;

  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(USER_ID)
        .get()
        .then((value) {
      userData = UserData.fromJson(value.data());
      print(userData.userName);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error));
    });
  }

  int bottomNavBarIndex = 0;

  List<Widget> screens = [
    const NewsFeedScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'News feed',
    'Chats',
    'New Post',
    'Users',
    'Settings',
  ];

  void changeBottomNavBarIndex(int index) {
    if (index == 1) {
      getUsers();
    }
    if (index != 2) {
      bottomNavBarIndex = index;
      emit(ChangeBottomNavBarIndexState());
    } else {
      emit(NewPostState());
    }
  }

  void logout(BuildContext context) {
    CacheHelper.removeString('userId').then((value) {
      navigateAndRemove(
        context,
        LoginScreen(),
      );
      emit(LogoutState());
    });
  }

  final ImagePicker picker = ImagePicker();

  XFile? profileImageFile;
  XFile? coverImageFile;
  XFile? postImageFile;

  void pickImage({required ImageTypes imageTypes}) async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      switch (imageTypes) {
        case ImageTypes.profileImage:
          {
            profileImageFile = pickedImage;
            break;
          }
        case ImageTypes.coverImage:
          {
            coverImageFile = pickedImage;
            break;
          }
        case ImageTypes.postImage:
          {
            postImageFile = pickedImage;
            break;
          }
      }
      emit(PickImageState());
    } else {
      emit(NoPickImageState());
    }
  }

  void clearImageFile({required bool isEditingProfile}) {
    if (isEditingProfile) {
      profileImageFile = null;
      coverImageFile = null;
    } else {
      postImageFile = null;
    }
    emit(ClearImageFileState());
  }

  void updateProfile({
    required String userName,
    required String phoneNumber,
    required String bio,
  }) async {
    emit(UpdateLoadingState());
    try {
      if (profileImageFile != null && coverImageFile != null) {
        final String? profileImageUrl =
            await _uploadImage(ImageTypes.profileImage);
        final String? coverImageUrl = await _uploadImage(ImageTypes.coverImage);
        if (profileImageUrl != null && coverImageUrl != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(USER_ID)
              .update(UserData(
                userName: userName,
                id: USER_ID,
                emailAddress: userData.emailAddress,
                phoneNumber: phoneNumber,
                bio: bio,
                profileImage: profileImageUrl,
                coverImage: coverImageUrl,
              ).toMap());
        }
      } else if (profileImageFile != null) {
        final String? profileImageUrl =
            await _uploadImage(ImageTypes.profileImage);
        if (profileImageUrl != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(USER_ID)
              .update(UserData(
                userName: userName,
                id: USER_ID,
                emailAddress: userData.emailAddress,
                phoneNumber: phoneNumber,
                bio: bio,
                profileImage: profileImageUrl,
                coverImage: userData.coverImage,
              ).toMap());
        }
      } else if (coverImageFile != null) {
        final String? coverImageUrl = await _uploadImage(ImageTypes.coverImage);
        if (coverImageUrl != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(USER_ID)
              .update(UserData(
                userName: userName,
                id: USER_ID,
                emailAddress: userData.emailAddress,
                phoneNumber: phoneNumber,
                bio: bio,
                profileImage: userData.profileImage,
                coverImage: coverImageUrl,
              ).toMap());
        }
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(USER_ID)
            .update(UserData(
              userName: userName,
              id: USER_ID,
              emailAddress: userData.emailAddress,
              phoneNumber: phoneNumber,
              bio: bio,
              profileImage: userData.profileImage,
              coverImage: userData.coverImage,
            ).toMap());
      }

      emit(UpdateSuccessState());
    } catch (error) {
      emit(UpdateErrorState());
    }
  }

  Future<String?> _uploadImage(ImageTypes imageType) async {
    final TaskSnapshot taskSnapshot;
    try {
      switch (imageType) {
        case ImageTypes.profileImage:
          {
            taskSnapshot = await FirebaseStorage.instance
                .ref()
                .child(
                    'Users/${userData.id}/Profile Images/${Uri.file(profileImageFile!.path).pathSegments.last}')
                .putFile(File(profileImageFile!.path));
            break;
          }
        case ImageTypes.coverImage:
          {
            taskSnapshot = await FirebaseStorage.instance
                .ref()
                .child(
                    'Users/${userData.id}/Cover Images/${Uri.file(coverImageFile!.path).pathSegments.last}')
                .putFile(File(coverImageFile!.path));
            break;
          }
        case ImageTypes.postImage:
          {
            taskSnapshot = await FirebaseStorage.instance
                .ref()
                .child(
                    'Posts/${userData.id}/${Uri.file(postImageFile!.path).pathSegments.last}')
                .putFile(File(postImageFile!.path));
            break;
          }
      }

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      return null;
    }
  }

  PostModel? postModel;

  void createPost({
    required String? postText,
  }) async {
    final String? postImageUrl;
    emit(CreatePostLoadingState());
    try {
      postImageUrl = await _uploadImage(ImageTypes.postImage);
      PostModel model = PostModel(
        userName: userData.userName,
        userId: userData.id,
        profileImage: userData.profileImage,
        postTime: '${DateTime.now()}',
        postText: postText,
        postImage: postImageUrl,
      );
      await FirebaseFirestore.instance.collection('Posts').add(model.toMap());
      getPosts();
      emit(CreatePostSuccessState());
    } catch (error) {
      emit(CreatePostErrorState());
    }
  }

  late List<PostModel> posts;

  void getPosts() {
    emit(GetUserLoadingState());
    posts = [];
    FirebaseFirestore.instance.collection('Posts').get().then((value) {
      for (var element in value.docs) {
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(GetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetPostsErrorState());
    });
  }

  void textFieldChanged(String text) {
    if (text.isEmpty) {
      emit(EmptyTextFieldState());
    } else {
      emit(NotEmptyTextFieldState());
    }
  }

  List<UserData> users = [];

  void getUsers() {
    if (users.isEmpty) {
      emit(GetUserLoadingState());
      FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var element in value.docs) {
          if (element.id != USER_ID) {
            users.add(UserData.fromJson(element.data()));
          }
        }
        emit(GetUserSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetUsersErrorState());
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String messageText,
  }) async {
    String randomString = getRandomString(20);
    MessageModel model = MessageModel(
      messageId: randomString,
      senderId: USER_ID,
      receiverId: receiverId,
      messageText: messageText,
      messageTime: DateTime.now().toString(),
    );
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(USER_ID)
          .collection('Chats')
          .doc(receiverId)
          .collection('Messages')
          .doc(randomString)
          .set(model.toMap());
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(receiverId)
          .collection('Chats')
          .doc(USER_ID)
          .collection('Messages')
          .doc(randomString)
          .set(model.toMap());
      emit(SendMessageSuccessState());
    } catch (error) {
      emit(SendMessageErrorState());
    }
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(USER_ID)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .orderBy('messageTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessagesSuccessState());
    });
  }
}
