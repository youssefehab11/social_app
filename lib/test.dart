import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  void _showBackDialog() {
    Navigator.pop(context);
    FocusManager.instance.primaryFocus?.unfocus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop){
          if(didPop) {
            return;
          }
          _showBackDialog();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter Text',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
