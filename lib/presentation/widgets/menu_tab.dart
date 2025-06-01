import 'package:flutter/material.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [menuItem('Menu'), menuItem('New'), menuItem('Undo')],
      ),
    );
  }

  Container menuItem(String title) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 67, 66, 66),
            Color.fromARGB(255, 135, 133, 133),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 2),
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
