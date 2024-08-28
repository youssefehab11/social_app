import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/styles.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Users',
        style: titleStyle,
      ),
    );
  }
}