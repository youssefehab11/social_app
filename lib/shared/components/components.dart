import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../styles/styles.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String?)? validator,
  required String label,
  required TextInputType textInputType,
  required TextInputAction textInputAction,
  required BuildContext context,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isInputVisible = true,
  bool isReadOnly = false,
  Function(String)? onChange,
  Function(String)? onFieldSubmitted,
  void Function()? onPressed,
  FocusNode? focusNode,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    validator: validator,
    style: const TextStyle(
      fontSize: 18.0,
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      label: Text(
        label,
      ),
      errorStyle: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        prefixIcon,
      ),
      suffixIcon: focusNode?.hasFocus != false
          ? IconButton(
              onPressed: onPressed,
              icon: Icon(
                suffixIcon,
              ),
              //splashColor: Colors.transparent,
            )
          : null,
    ),
    keyboardType: textInputType,
    textInputAction: textInputAction,
    obscureText: !isInputVisible,
    readOnly: isReadOnly,
    onChanged: onChange,
    onFieldSubmitted: onFieldSubmitted,
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
  );
}

Widget defaultButton({
  required String label,
  required void Function()? onPressed,
  required double labelFont,
  required double buttonWidth,
}) {
  return SizedBox(
    width: buttonWidth,
    height: 50.0,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: labelStyle.copyWith(
          color: Colors.white,
          fontSize: labelFont,
        ),
      ),
    ),
  );
}

Widget defaultTextButton({
  required String label,
  required void Function()? onPressed,
  required TextStyle labelStyle,
  IconData? icon,
  Color? iconColor,
  ButtonStyle? style,
}) {
  return TextButton.icon(
    onPressed: onPressed,
    style: style,
    icon: icon != null
        ? Icon(
            icon,
            color: iconColor,
          )
        : const SizedBox(
            width: 0,
          ),
    label: Text(
      label,
      style: labelStyle,
    ),
  );
}

void showToast({
  required String message,
  required BuildContext context,
  required Color? color,
  IconData? icon,
  int duration = 2000,
  Color textColor = Colors.white,
  Color iconColor = Colors.white,
}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon != null
            ? Icon(
                icon,
                color: iconColor,
              )
            : const SizedBox(
                width: 0.0,
              ),
        const SizedBox(
          width: 12.0,
        ),
        Flexible(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(milliseconds: duration),
  );
}

Widget defaultIconButton({
  required void Function()? onPressed,
  required IconData icon,
  required Color iconColor,
  Color? splashColor,
  double? splashRadius,
}) {
  return IconButton(
    onPressed: onPressed,
    splashColor: splashColor,
    splashRadius: splashRadius,
    padding: EdgeInsets.zero,
    icon: Icon(
      icon,
      color: iconColor,
    ),
  );
}

Widget myDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 10.0,
    ),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  );
}

Widget circularLoading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  Text? title,
  bool hasArrowBack = false,
  List<Widget>? actions,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: title,
    ),
    leading: hasArrowBack
        ? defaultIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            splashColor: Colors.transparent,
            splashRadius: 0.1,
            icon: IconBroken.Arrow___Left_2,
            iconColor: Colors.black,
          )
        : null,
    actions: actions,
  );
}
