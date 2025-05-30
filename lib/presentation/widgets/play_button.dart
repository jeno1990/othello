import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.centerTitle,
    this.shadowColor,
  });
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool? centerTitle;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: Color(0xff18786a),
          // gradient: LinearGradient(

          //   colors: [
          //     Colors.lightGreenAccent,
          //     Color(0xff18786a),
          //     Colors.lightGreenAccent,
          //   ],
          // ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              centerTitle != null && centerTitle!
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, size: 24, color: Colors.white),
            if (icon != null) SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
