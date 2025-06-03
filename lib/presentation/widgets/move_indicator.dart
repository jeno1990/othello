import 'package:flutter/material.dart';

class ValidMoveIndicator extends StatefulWidget {
  const ValidMoveIndicator({super.key});

  @override
  _ValidMoveIndicatorState createState() => _ValidMoveIndicatorState();
}

class _ValidMoveIndicatorState extends State<ValidMoveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _scale = Tween<double>(
      begin: 1.2,
      end: .8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacity = Tween<double>(
      begin: 0.6,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stack a fading circle behind a solid dot if you like, or just show one circle.
    return Container(
      width: 23,
      height: 23,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black45),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
