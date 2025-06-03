import 'package:flutter/material.dart';

class WinnerPopup extends StatelessWidget {
  final int blackCount;
  final int whiteCount;
  final VoidCallback onRestart;

  const WinnerPopup({
    super.key,
    required this.blackCount,
    required this.whiteCount,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    String winnerText;
    if (blackCount > whiteCount) {
      winnerText = '⚫ Black Wins!';
    } else if (whiteCount > blackCount) {
      winnerText = '⚪ White Wins!';
    } else {
      winnerText = '🤝 It\'s a Tie!';
    }

    return Dialog(
      backgroundColor: const Color(0xff2D4A7F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(0, 2)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              winnerText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.yellowAccent,
                shadows: [
                  Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 2)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '⚫ Black: $blackCount\n⚪ White: $whiteCount',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onRestart();
              },
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
