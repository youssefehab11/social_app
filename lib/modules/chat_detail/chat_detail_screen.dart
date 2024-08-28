import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/models/message.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserData userData;

  ChatDetailsScreen({super.key, required this.userData});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        cubit.getMessages(receiverId: userData.id);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(userData.profileImage),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    userData.userName,
                    style: defaultFont,
                  ),
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      MessageModel message = cubit.messages[index];
                      if (USER_ID == message.senderId) {
                        return myMessage(
                          context: context,
                          messageModel: message,
                        );
                      } else {
                        return friendMessage(
                          messageModel: message,
                        );
                      }
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                    itemCount: cubit.messages.length,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: defaultFont.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                        ),
                        onChanged: (String text) {
                          cubit.textFieldChanged(text);
                        },
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ElevatedButton(
                        onPressed: messageController.text.isNotEmpty
                            ? () {
                                cubit.sendMessage(
                                  receiverId: userData.id,
                                  messageText: messageController.text,
                                );
                                messageController.text = '';
                              }
                            : null,
                        child: const Icon(
                          IconBroken.Send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget friendMessage({
    required MessageModel messageModel,
  }) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(messageBorderRadius),
              topStart: Radius.circular(messageBorderRadius),
              bottomEnd: Radius.circular(messageBorderRadius),
            )),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            messageModel.messageText,
            style: defaultFont.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget myMessage({
    required BuildContext context,
    required MessageModel messageModel,
  }) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(messageBorderRadius),
              topStart: Radius.circular(messageBorderRadius),
              bottomStart: Radius.circular(messageBorderRadius),
            )),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            messageModel.messageText,
            style: defaultFont.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
