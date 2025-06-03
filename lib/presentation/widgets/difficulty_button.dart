import 'package:flutter/material.dart';

class DifficultyButton extends StatelessWidget {
  const DifficultyButton({
    super.key,
    required this.text,
    required this.color,
    required this.selected,
    required this.onPressed,
  });

  final String text;
  final Color color;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300,
                height: 2,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      selected ? Colors.white : Colors.white.withOpacity(0.6),
                      selected ? Colors.white : Colors.white.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: selected ? 20 : 18,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color:
                        selected ? Colors.white : Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 2,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      selected ? Colors.white : Colors.white.withOpacity(0.6),
                      selected ? Colors.white : Colors.white.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
