import 'package:auther_client/src/core/assets/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

class LogoPainter extends StatelessWidget {
  const LogoPainter({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.fromHeight(Theme.of(context).textTheme.titleLarge!.fontSize!),
        painter: _LogoPainter(
          logoStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.orbitron,
              ),
        ),
      );
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({
    required this.logoStyle,
  });

  final TextStyle logoStyle;

  late final textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: 'Auther',
      style: logoStyle,
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    textPainter
      ..layout(maxWidth: size.width)
      ..paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
