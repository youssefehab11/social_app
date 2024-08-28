
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/modules/chat_detail/chat_detail_screen.dart';
import 'package:social_app/shared/navigation/navigation.dart';
import 'package:social_app/shared/styles/styles.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return chatItem(cubit.users[index], context);
          },
          separatorBuilder: (context, index)=> Container(width: double.infinity,height: 1,color: Colors.grey[300],),
          itemCount: cubit.users.length,
        );
      },
    );
  }

  Widget chatItem(UserData model, BuildContext context) {
    return InkWell(
      onTap: (){
        navigateTo(context, ChatDetailsScreen(userData: model));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(model.profileImage),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: Text(
                model.userName,
                style: defaultFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
