import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

void navigateAndRemove(BuildContext context, Widget destination) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => destination),
    (route) => false,
  );
}