import 'package:flutter/material.dart';

class CurvedBtn extends StatelessWidget {
  final String btnText;

  final IconData? btnIcon;
  final void Function()? onClick;
  final double horizontal;
  final double vertical;
  final Color? bg;
  final Color? txtolor;
  final Color? iconColor;
  const CurvedBtn({
    required this.btnText,
    this.btnIcon,
    super.key,
    this.onClick,
    this.horizontal = 20,
    this.bg = Colors.white,
    this.txtolor = Colors.black,
    this.iconColor = Colors.white,
    this.vertical = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onClick ?? () {},
      label: Center(
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: txtolor,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      icon: Visibility(
        visible: btnIcon != null,
        child: Icon(btnIcon, color: iconColor),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        backgroundColor: bg,
      ),
    );
  }
}
