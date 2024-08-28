import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/styles/styles.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              poster(),
              Builder(
                builder: (context) {
                  if (state is GetUserLoadingState) {
                    return circularLoading();
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          postItem(cubit.posts[index], cubit),
                      itemCount: cubit.posts.length,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget poster() {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      //margin: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.network(
            'https://img.freepik.com/free-photo/handsome-caucasian-male-model-glasses-pointing-fingers-right-your-logo-showing-copy-space-stan_1258-163691.jpg?w=1380&t=st=1710098284~exp=1710098884~hmac=bcc0b101805c4a4c65077be4857e2aebe242a029390e8208c928e3a7fc3cc827',
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Communicate with friends',
              style: labelStyle.copyWith(letterSpacing: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget postItem(PostModel postModel, AppCubit cubit) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            postInfo(postModel, cubit.userData),
            myDivider(),
            postDetails(postModel),
            myDivider(),
            postInterAction(cubit),
          ],
        ),
      ),
    );
  }

  Widget postInfo(PostModel postModel, UserData userData) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35.0,
          backgroundImage: postModel.userId == USER_ID ?NetworkImage(userData.profileImage): NetworkImage(postModel.profileImage) ,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(postModel.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  const Baseline(
                    baseline: 15.5,
                    baselineType: TextBaseline.alphabetic,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 18.0,
                    ),
                  )
                ],
              ),
              Text(
                postModel.postTime,
                style: caption.copyWith(height: 1.3, fontSize: 14),
              ),
            ],
          ),
        ),
        Baseline(
          baseline: 16,
          baselineType: TextBaseline.alphabetic,
          child: defaultIconButton(
            onPressed: () {
              /*TODO*/
            },
            icon: Icons.more_horiz,
            iconColor: Colors.black87,
            splashColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget postDetails(PostModel postModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post description
        if (postModel.postText != null)
          Text(
            postModel.postText!,
            style: defaultFont,
          ),

        // Post hashtags
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   child: Wrap(
        //     children: [
        //       SizedBox(
        //         height: 25.0,
        //         child: MaterialButton(
        //           textColor: Colors.blue,
        //           padding: const EdgeInsetsDirectional.only(end: 5.0),
        //           minWidth: 1.0,
        //           height: 25,
        //           splashColor: Colors.transparent,
        //           onPressed: () {},
        //           child: Text('#software',
        //               style: caption.copyWith(
        //                 color: Colors.blue,
        //                 fontWeight: FontWeight.w500,
        //               )),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 25.0,
        //         child: MaterialButton(
        //           textColor: Colors.blue,
        //           padding: const EdgeInsetsDirectional.only(end: 5.0),
        //           minWidth: 1.0,
        //           height: 25,
        //           splashColor: Colors.transparent,
        //           onPressed: () {},
        //           child: const Text(
        //             '#flutter',
        //             style: TextStyle(
        //                 color: Colors.blue,
        //                 fontSize: 16.0,
        //                 fontWeight: FontWeight.w500),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Post Image
        if (postModel.postImage != null)
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image(
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              image: NetworkImage(postModel.postImage!),
            ),
          ),

        // Number of Reactions
        Row(
          children: [
            defaultTextButton(
              label: '0',
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
              icon: IconBroken.Heart,
              iconColor: Colors.red,
              onPressed: () {
                /*TODO*/
              },
              labelStyle: caption,
            ),
            const Spacer(),
            defaultTextButton(
              label: '0 Comment',
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
              icon: IconBroken.Chat,
              iconColor: Colors.amber,
              onPressed: () {
                /*TODO*/
              },
              labelStyle: caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget postInterAction(AppCubit cubit) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(
            cubit.userData.profileImage,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            splashColor: Colors.transparent,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Write a comment...',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        defaultTextButton(
          label: 'Like',
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red.shade50)),
          icon: IconBroken.Heart,
          iconColor: Colors.red,
          onPressed: () {
            /*TODO*/
          },
          labelStyle: caption,
        ),
      ],
    );
  }
}
