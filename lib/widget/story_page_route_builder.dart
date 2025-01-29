import 'package:flutter/material.dart';

final class StoryPageRouteBuilder extends PageRouteBuilder {
  final Offset tapPosition;

  StoryPageRouteBuilder({
    required super.pageBuilder,
    required this.tapPosition,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final screenSize = MediaQuery.of(context).size;

            // Calculate the scale alignment based on tap position
            final alignmentX = (tapPosition.dx / screenSize.width) * 2 - 1;
            final alignmentY = (tapPosition.dy / screenSize.height) * 2 - 1;

            return ScaleTransition(
              alignment: Alignment(alignmentX, alignmentY),
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            );
          },
        );
}

final class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset centerOffset;

  CircularRevealClipper({
    required this.fraction,
    required this.centerOffset,
  });

  @override
  Path getClip(Size size) {
    final radius = fraction * size.longestSide * 1.5;
    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: centerOffset,
          radius: radius,
        ),
      );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
